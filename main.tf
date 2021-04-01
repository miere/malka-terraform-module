provider "local" {}
provider "docker" {
  registry_auth {
    address = "${local.account_id}.dkr.ecr.${var.region}.amazonaws.com"
    username = local.ecr_username
    password = local.ecr_password
  }
}

locals {
  account_id = data.aws_caller_identity.default.account_id
  ecr_username = data.aws_ecr_authorization_token.default.user_name
  ecr_password = data.aws_ecr_authorization_token.default.password
}

output "account_id" {
  value = local.account_id
}

data "aws_ecr_authorization_token" "default" {}
data "aws_caller_identity" "default" {}

terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "2.11.0"
    }
    local = {
      source = "hashicorp/local"
      version = "2.1.0"
    }
  }
}
