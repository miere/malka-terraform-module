data "aws_iam_policy_document" "default" {
  statement {
    actions = ["lambda:InvokeFunction"]
    resources = local.function_arns
  }
}

resource "aws_iam_policy" "default" {
  name   = "malka-${var.environment}-extra"
  policy = data.aws_iam_policy_document.default.json
}

resource "aws_iam_role_policy_attachment" "default" {
  role = module.ecs_service.iam_role_name
  policy_arn = aws_iam_policy.default.arn
}