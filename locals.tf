locals {
  default_tags = merge(var.default_tags, { "AppRole" : var.app_role, "Environment" : upper(var.env), "Project" : var.namespace })
  name_prefix  = "${var.namespace}-${var.env}"

  #So if ever there is a change in the remote data outputs no need to update the main.
  remote_states = { for k, v in data.terraform_remote_state.this : k => v.outputs }
  vpcs          = { for k, v in local.remote_states : k => v.vpcs }
  route_tables  = { for k, v in local.remote_states : k => v.route_tables }
}