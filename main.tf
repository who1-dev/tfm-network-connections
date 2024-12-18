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
  depends_on                = [aws_vpc_peering_connection.this]
}
