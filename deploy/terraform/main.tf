# Stubbed out (not working)

resource "aws_lambda_function" "send_to_gist" {
  function_name    = "send_to_gist"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  publish          = true
  provider         = variable.AWS_REGION
  memory_size      = "32"
  timeout          = 1
  filename         = "dist/build.zip"
  source_code_hash = filebase64sha256("dist/build.zip")
}

resource "aws_api_gateway_rest_api" "rest_api" {
  name        = "ServerlessExample"
  description = "Terraform Serverless Application Example"
}

resource "aws_api_gateway_resource" "proxy" {
   rest_api_id = aws_api_gateway_rest_api.rest_api.id
   parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
   path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy" {
   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
   resource_id   = aws_api_gateway_resource.proxy.id
   http_method   = "ANY"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "lambda" {
   rest_api_id = aws_api_gateway_rest_api.rest_api.id
   resource_id = aws_api_gateway_method.proxy.resource_id
   http_method = aws_api_gateway_method.proxy.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.send_to_gist.invoke_arn
}

resource "aws_api_gateway_deployment" "example" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.rest_api.id
   stage_name  = "test"
}
