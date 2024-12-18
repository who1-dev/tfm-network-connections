variable "default_tags" {
  type        = map(any)
  description = "Default tags to be applied to all AWS resources"
}

variable "app_role" {
  type    = string
  default = "Network Connection"
}

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "namespace" {
  type = string
}

variable "env" {
  type = string
}

variable "remote_data_sources" {
  type = map(object({
    bucket = string
    key    = string
    region = string
  }))
  default = {
  }
}

variable "vpc_peering_connections" {
  type = map(object({
    source_remote_key = string
    source_vpc_key    = string #Module 'network' > 'output' > 'vpcs'
    peer_remote_key   = string
    peer_vpc_key      = string #Module 'network' > 'output' > 'vpcs'
    name              = string
  }))
  default = {
  }
}

variable "vpc_peering_connection_routes" {
  type = map(object({
    source_remote_key          = string
    source_rt_key              = string #Module 'network' > 'output' > 'route_tables'
    dest_remote_key            = string
    dest_cidr_block_vpc_key    = string #Module 'network' > 'output' > 'vpcs' contains the CIDR
    vpc_peering_connection_key = string #Key will be from "var.vpc_peering_connections"
  }))
  default = {
  }
}