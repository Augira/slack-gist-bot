# Stubbed out (not working)

resource "aws_lambda_function" "send_to_gist" {
  function_name    = "send_to_gist"
  handler          = "index.handler"
  runtime          = "nodejs12.x"
  publish          = true
  # provider         = var.AWS_REGION
  memory_size      = "128"
  timeout          = 1
  filename         = "../../dist/build.zip"
  source_code_hash = filebase64sha256("../../dist/build.zip")

  role = aws_iam_role.lambda_exec.arn
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_gister"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
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

resource "aws_api_gateway_method" "proxy_root" {
   rest_api_id   = aws_api_gateway_rest_api.rest_api.id
   resource_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
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

resource "aws_api_gateway_integration" "lambda_root" {
   rest_api_id = aws_api_gateway_rest_api.rest_api.id
   resource_id = aws_api_gateway_method.proxy_root.resource_id
   http_method = aws_api_gateway_method.proxy_root.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.send_to_gist.invoke_arn
}

resource "aws_api_gateway_deployment" "api_deployment" {
   depends_on = [
     aws_api_gateway_integration.lambda,
     aws_api_gateway_integration.lambda_root,
   ]

   rest_api_id = aws_api_gateway_rest_api.rest_api.id
   stage_name  = "test"
}

resource "aws_lambda_permission" "apigw" {
   statement_id  = "AllowAPIGatewayInvoke"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.send_to_gist.function_name
   principal     = "apigateway.amazonaws.com"

   # The "/*/*" portion grants access from any method on any resource
   # within the API Gateway REST API.
   source_arn = "${aws_api_gateway_rest_api.rest_api.execution_arn}/*/*"
}
