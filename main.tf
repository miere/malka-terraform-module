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

provider "local" {}
provider "docker" {
  registry_auth {
    address = "${local.account_id}.dkr.ecr.${local.aws_region}.amazonaws.com"
    username = local.ecr_username
    password = local.ecr_password
  }
}
