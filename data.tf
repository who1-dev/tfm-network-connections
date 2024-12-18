data "terraform_remote_state" "this" {
  for_each = var.remote_data_sources
  backend  = "s3"
  config = {
    bucket = each.value.bucket
    key    = "${var.env}/${each.value.key}"
    region = var.region
  }
}