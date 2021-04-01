resource "aws_security_group" "default" {
  name   = "${var.name}-${var.environment}"
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port = 0
    to_port   = 0
    protocol    = "-1"
    cidr_blocks = [data.aws_vpc.default.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# The VPC ID defined for this task
data "aws_vpc" "default" {
  id = var.vpc_id
}