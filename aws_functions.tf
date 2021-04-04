locals {
  configuration_json = jsondecode(var.configuration)
  functions = flatten(local.configuration_json[*]["target_functions"])
  function_arns = data.aws_lambda_function.functions.*.arn
}

data "aws_lambda_function" "functions" {
  count = length(local.functions)
  function_name = local.functions[count.index]
}

