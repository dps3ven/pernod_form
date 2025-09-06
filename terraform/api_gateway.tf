resource "aws_api_gateway_rest_api" "residency_checker_api" {
  name        = "residency_checker_api"
  description = "API for Vindot Residency Checking"
}

resource "aws_api_gateway_stage" "dev" {
  rest_api_id   = aws_api_gateway_rest_api.residency_checker_api.id
  stage_name    = "dev"
  deployment_id = aws_api_gateway_deployment.deployment.id
}

import {
  to = aws_api_gateway_stage.dev
  id = "1xbqvgjn40/dev"
}

resource "aws_api_gateway_deployment" "deployment" {
  rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
  
  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_method.post,
      aws_api_gateway_integration.post,
    ]))
  }
  
  lifecycle {
    create_before_destroy = true
  }
}

import {
  to = aws_api_gateway_deployment.deployment
  id = "1xbqvgjn40/c2ovcc"
}

data "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
  path        = "/"
}

# resource "aws_api_gateway_resource" "resource" { ## remove from state
#   rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
#   parent_id   = aws_api_gateway_rest_api.residency_checker_api.root_resource_id
#   path_part   = "/"

# }

# import {
#   to = aws_api_gateway_resource.resource
#   id = "1xbqvgjn40/baxdjn5t7b"
# }

resource "aws_api_gateway_method" "post" {
  rest_api_id   = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id   = data.aws_api_gateway_resource.resource.id
  http_method   = "POST"
  authorization = "NONE"
}

import {
  to = aws_api_gateway_method.post
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/POST"
}

resource "aws_api_gateway_integration" "post" {
  rest_api_id             = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id             = data.aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.post.http_method
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda.invoke_arn
  content_handling        = "CONVERT_TO_TEXT"
  cache_namespace         = data.aws_api_gateway_resource.resource.id
  cache_key_parameters    = []
  passthrough_behavior    = "WHEN_NO_MATCH"
  integration_http_method = "POST"
}

import {
  to = aws_api_gateway_integration.post
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/POST"

}

resource "aws_api_gateway_method_response" "response_200" {
  rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id = data.aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

import {
  to = aws_api_gateway_method_response.response_200
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/${aws_api_gateway_method.post.http_method}/200"

}


resource "aws_api_gateway_integration_response" "post_integration_reponse" {
  rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id = data.aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.post.http_method
  status_code = aws_api_gateway_method_response.response_200.status_code

  # response_parameters = {
  #   "method.response.header.Access-Control-Allow-Origin" : "'*'"
  # }
  response_templates = {
    "application/json" = null
  }
}

import {
  to = aws_api_gateway_integration_response.post_integration_reponse
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/${aws_api_gateway_method.post.http_method}/200"
}

