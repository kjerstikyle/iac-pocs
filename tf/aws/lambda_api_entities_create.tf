module "api_entities_create" {
  source          = "./modules/lambda"
  runtime         = "nodejs"
  function_type   = "api"
  function_name   = "entities_create"
  policy_document = data.aws_iam_policy_document.api_entities_create.json
  shared_params   = local.lambda_shared_params
  environments = merge(local.lambda_shared_environments, {
    SSM_PARAMETERS_ENV = local.environment
  })
}

data "aws_iam_policy_document" "api_entities_create" {
  statement {
    sid       = "GetParametersPermission"
    actions   = ["ssm:GetParameters"]
    resources = ["*"]
    effect    = "Allow"
  }
}

module "api_method-entities_POST" {
  source               = "./modules/api_method_lambda"
  shared_params        = local.api_method_shared_params
  resource_id          = module.resource_entities.resource_id
  path                 = module.resource_entities.resource_path
  method               = "POST"
  invoke_arn           = module.api_entities_create.invoke_arn
  authorization        = "CUSTOM"
  authorizer_id        = aws_api_gateway_authorizer.authorizer.id
  api_key_required     = true
  request_validator_id = module.api_gw.validate_all_id
  request_parameters = {
    "method.request.header.x-api-key"     = true
    "method.request.header.Authorization" = true
  }
}