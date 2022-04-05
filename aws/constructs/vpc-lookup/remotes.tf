locals {
  remote = defaults(var.remote, {
    account     = true
    environment = var.environment
  })
}

locals {
  tf_source = local.remote.account ? var.account : var.project
  tf_bucket = "${local.tf_source}-terraformstate-${var.region}-${local.remote.environment}-${var.namespace}"
  mapping   = data.terraform_remote_state.vpc.outputs
}

data "terraform_remote_state" "vpc" {
  backend = "s3"
  config = {
    bucket = local.tf_bucket
    key    = "vpc/terraform.tfstate"
    region = var.region
  }
}