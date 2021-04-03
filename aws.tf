locals {
  account_id = data.aws_caller_identity.default.account_id
  ecr_username = data.aws_ecr_authorization_token.default.user_name
  ecr_password = data.aws_ecr_authorization_token.default.password
  aws_region = data.aws_region.current.name
}

data "aws_ecr_authorization_token" "default" {}
data "aws_caller_identity" "default" {}
data "aws_region" "current" {}
