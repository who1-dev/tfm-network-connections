output "vpc_peering_connections" {
  value = { for k, v in aws_vpc_peering_connection.this :
    k => { id = k.id, name = k.name }
  }
}

output "transit_gateway" {
  value = { for k, v in aws_ec2_transit_gateway.this :
    k => {
      id          = v.id,
      description = v.description,
      attachments = { for k, val in aws_ec2_transit_gateway_vpc_attachment.this :
        k => { id = val.id, vpc_id = val.vpc_id, subnet_ids = val.subnet_ids } if val.transit_gateway_id == v.id
      }
    }
  }
}

