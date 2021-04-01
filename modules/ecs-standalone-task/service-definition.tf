# One ECS Service per worker
resource "aws_ecs_service" "default" {
    cluster = aws_ecs_cluster.default.name
    name = "${var.name}-${var.environment}"
    task_definition = "${aws_ecs_task_definition.default.family}:${aws_ecs_task_definition.default.revision}"

    launch_type     = "FARGATE"
    desired_count   = var.desired_count

    network_configuration {
        assign_public_ip = true
        security_groups  = [aws_security_group.default.id]
        subnets          = var.subnet_ids
    }

    dynamic "load_balancer" {
        for_each = var.target_groups
        content {
            target_group_arn = load_balancer.value["target_group_arn"]
            container_name   = load_balancer.value["container_name"]
            container_port   = load_balancer.value["container_port"]
        }
    }

    deployment_controller {
        type = "ECS"
    }
}

# One auto-scaling target group per service
resource "aws_appautoscaling_target" "default" {
    max_capacity       = var.max_capacity
    min_capacity       = var.min_capacity
    resource_id        = "service/${aws_ecs_cluster.default.name}/${aws_ecs_service.default.name}"
    scalable_dimension = "ecs:service:DesiredCount"
    service_namespace  = "ecs"
}

resource "aws_ecs_cluster" "default" {
    name = "${var.name}-${var.environment}"
}