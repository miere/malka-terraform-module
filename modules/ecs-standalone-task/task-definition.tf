# One ECS Task Definition per worker
locals {

    tasks = [
        for task in var.tasks: {
            name: task.name,
            image: task.image,
            essential: true,

            secrets: [for key in keys(task.secrets): {
                name = key
                valueFrom = task.secrets[key]
            }],

            environment: [for key in keys(task.env_vars): {
                name = key
                value = task.env_vars[key]
            }],

            logConfiguration: {
                logDriver: "awslogs",
                options: {
                    awslogs-region: var.aws_region
                    awslogs-create-group: "true"
                    awslogs-group: "${var.name}/${var.environment}"
                    awslogs-stream-prefix: task.name
                },
                secretOptions: []
            },

            # Explicit conf to avoid unneeded redeployment from terraform
            memoryReservation: 200,
            mountPoints: [],
            portMappings: [for ports in task.port_mappings: {
                containerPort: tonumber( split(":", ports)[1] ),
                hostPort: tonumber( split(":", ports)[0] ),
                protocol: "tcp"
            }],
            volumesFrom: [],
            cpu: 0
        }
    ]
}

resource "aws_ecs_task_definition" "default" {
    requires_compatibilities = ["FARGATE"]
    network_mode             = "awsvpc"

    family                   = "${var.name}-${var.environment}"
    cpu                      = var.cpu
    memory                   = var.memory

    execution_role_arn       = aws_iam_role.default.arn
    task_role_arn            = aws_iam_role.default.arn

    container_definitions    = jsonencode(local.tasks)
}
