#VPC Peering
resource "aws_vpc_peering_connection" "this" {
  for_each    = var.vpc_peering_connections
  vpc_id      = local.vpcs[each.value.source_remote_key][each.value.source_vpc_key].id
  peer_vpc_id = local.vpcs[each.value.peer_remote_key][each.value.peer_vpc_key].id
  auto_accept = true

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
}


#VPC Peering - Routes
resource "aws_route" "vpc_peering" {
  for_each                  = var.vpc_peering_connection_routes
  route_table_id            = local.route_tables[each.value.source_remote_key][each.value.source_rt_key]
  destination_cidr_block    = local.vpcs[each.value.dest_remote_key][each.value.dest_cidr_block_vpc_key].cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.this[each.value.vpc_peering_connection_key].id

  depends_on = [aws_vpc_peering_connection.this]
}


#Transit Gateway
resource "aws_ec2_transit_gateway" "this" {
  for_each    = var.transit_gateways
  description = each.value.description

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })
}

#Transit Gateway Attachment
resource "aws_ec2_transit_gateway_vpc_attachment" "this" {
  for_each           = var.transit_gateway_attachments
  transit_gateway_id = aws_ec2_transit_gateway.this[each.value.tg_key].id
  vpc_id             = local.vpcs[each.value.remote_key][each.value.vpc_key].id
  subnet_ids         = [for key in each.value.subnet_keys : local.subnets[each.value.remote_key][key]]

  tags = merge(local.default_tags, {
    Name = "${local.name_prefix}-${each.value.name}"
  })

  depends_on = [aws_ec2_transit_gateway.this]
}

#Transit Gateway Attachment - Routes
resource "aws_route" "transit_gateway" {
  for_each               = var.transit_gateway_routes
  route_table_id         = local.route_tables[each.value.source_remote_key][each.value.source_rt_key]
  destination_cidr_block = local.vpcs[each.value.dest_remote_key][each.value.dest_cidr_block_vpc_key].cidr_block
  transit_gateway_id     = aws_ec2_transit_gateway.this[each.value.tg_key].id
}
