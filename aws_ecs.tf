locals {
  hashed_docker_file = sha256(data.template_file.dockerfile.rendered)
  hashed_config_file = sha256(jsonencode(var.configuration))
  computed_version_id = sha256("${local.hashed_config_file}-${local.hashed_docker_file}")
  remote_docker_image = "${aws_ecr_repository.default_image.repository_url}:${local.computed_version_id}"
}

module "ecs_service" {
  source = "./modules/ecs-standalone-task"

  name = var.name
  environment = var.environment

  subnet_ids = var.subnet_ids
  vpc_id = var.vpc_id

  min_capacity = var.min_capacity
  max_capacity = var.max_capacity

  cpu = var.cpu
  memory = var.memory

  tasks = [{
    name = var.name,
    image = local.remote_docker_image,
    env_vars = {
      "KAFKA_BROKERS" = join(",", var.kafka_brokers)
      "KAFKA_SECURITY_PROTOCOL" = var.kafka_security_protocol
    }
    secrets = {}
    port_mappings = []
  }]
}

resource "aws_ecr_repository" "default_image" {
  name = "malka-${var.environment}"
  image_tag_mutability = "MUTABLE" # or "IMMUTABLE"
}

data "template_file" "dockerfile" {
  template = file("${path.module}/Dockerfile.tpl")
  vars = {
    malka_version = "latest"
  }
}

resource "local_file" "dockerfile" {
  content  = data.template_file.dockerfile.rendered
  filename = "${path.cwd}/Dockerfile.generated"
}

resource "local_file" "config" {
  content  = jsonencode(var.configuration)
  filename = "${path.cwd}/configuration.generated"
}

resource "docker_registry_image" "custom" {
  name = local.remote_docker_image
  build {
    context = path.cwd
    dockerfile = "Dockerfile.generated"
  }
}
