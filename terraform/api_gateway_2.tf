resource "aws_api_gateway_method" "options" {
  rest_api_id   = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id   = data.aws_api_gateway_resource.resource.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

import {
  to = aws_api_gateway_method.options
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/OPTIONS"
}

resource "aws_api_gateway_integration" "options" {
  rest_api_id          = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id          = data.aws_api_gateway_resource.resource.id
  http_method          = aws_api_gateway_method.options.http_method
  type                 = "MOCK"
  content_handling     = "CONVERT_TO_TEXT"
  cache_namespace      = data.aws_api_gateway_resource.resource.id
  cache_key_parameters = []
  passthrough_behavior = "WHEN_NO_MATCH"
  request_templates = {
    "application/json" = jsonencode(
      {
        "statusCode" = 200
      }
    )
  }
}

import {
  to = aws_api_gateway_integration.options
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/OPTIONS"

}

resource "aws_api_gateway_method_response" "options_response_200" {
  rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id = data.aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = false,
    "method.response.header.Access-Control-Allow-Methods" = false,
    "method.response.header.Access-Control-Allow-Origin"  = false

  }
}

import {
  to = aws_api_gateway_method_response.options_response_200
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/${aws_api_gateway_method.options.http_method}/200"

}


resource "aws_api_gateway_integration_response" "options_integration_reponse" {
  rest_api_id = aws_api_gateway_rest_api.residency_checker_api.id
  resource_id = data.aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.options.http_method
  status_code = aws_api_gateway_method_response.options_response_200.status_code

  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'OPTIONS,POST'",
    "method.response.header.Access-Control-Allow-Origin"  = "'*'"
  }
  response_templates = {
    "application/json" = null
  }
}

import {
  to = aws_api_gateway_integration_response.options_integration_reponse
  id = "1xbqvgjn40/${data.aws_api_gateway_resource.resource.id}/${aws_api_gateway_method.options.http_method}/200"
}

