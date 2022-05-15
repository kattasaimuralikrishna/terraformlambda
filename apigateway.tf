#api Gateway Rest API
resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "apiLambda"

}

#Health Resource
resource "aws_api_gateway_resource" "health" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "health"

}

#Health Method
resource "aws_api_gateway_method" "healthget" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.health.id
   http_method   = "GET"
   authorization = "NONE"
}
#Health Integration
resource "aws_api_gateway_integration" "health" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.health.id
   http_method = aws_api_gateway_method.healthget.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Lambda.invoke_arn
   
}

#HealthMethod Response
resource "aws_api_gateway_method_response" "healthresponse_200" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.healthget.http_method
  status_code = "200"
}

#Health Integration response

resource "aws_api_gateway_integration_response" "healthgetintegration" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.health.id
  http_method = aws_api_gateway_method.healthget.http_method
  status_code = aws_api_gateway_method_response.healthresponse_200.status_code
  depends_on = [
    aws_api_gateway_integration.health
  ]
  response_templates = {
    "application/json" = ""
  }
}


#Product Resource
resource "aws_api_gateway_resource" "product" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "product"

}

#Product Method
resource "aws_api_gateway_method" "prodget" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.product.id
   http_method   = "GET"
   authorization = "NONE"
}

resource "aws_api_gateway_method" "productpost" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.product.id
   http_method   = "POST"
   authorization = "NONE"
}

resource "aws_api_gateway_method" "productdelete" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.product.id
   http_method   = "DELETE"
   authorization = "NONE"
}


#Product Integration
resource "aws_api_gateway_integration" "getproduct" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.product.id
   http_method = aws_api_gateway_method.prodget.http_method 

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Lambda.invoke_arn
   
}
resource "aws_api_gateway_integration" "postproduct" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.product.id
   http_method = aws_api_gateway_method.productpost.http_method 

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Lambda.invoke_arn
   
}
resource "aws_api_gateway_integration" "deleteproduct" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.product.id
   http_method = aws_api_gateway_method.productdelete.http_method 

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.Lambda.invoke_arn
   
}

#Product Method Response
resource "aws_api_gateway_method_response" "productgetresponse_200" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.prodget.http_method 
                  
  status_code = "200"
}
resource "aws_api_gateway_method_response" "productpostresponse_200" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.productpost.http_method  
                  
  status_code = "200"
}
resource "aws_api_gateway_method_response" "productdeleteresponse_200" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.productdelete.http_method
                  
  status_code = "200"
}

#Product Integration response

resource "aws_api_gateway_integration_response" "productgetintegration" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.prodget.http_method 
  status_code = aws_api_gateway_method_response.productgetresponse_200.status_code
  depends_on = [
    aws_api_gateway_integration.getproduct
  ]
  response_templates = {
    "application/json" = ""
  }
}
resource "aws_api_gateway_integration_response" "productpostintegration" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.productpost.http_method 
                  
                  
  status_code = aws_api_gateway_method_response.productpostresponse_200.status_code
  depends_on = [
    aws_api_gateway_integration.postproduct
  ]
  response_templates = {
    "application/json" = ""
  }
}
resource "aws_api_gateway_integration_response" "productdeleteintegration" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  resource_id = aws_api_gateway_resource.product.id
  http_method = aws_api_gateway_method.productdelete.http_method
                  
  status_code = aws_api_gateway_method_response.productdeleteresponse_200.status_code
  depends_on = [
    aws_api_gateway_integration.deleteproduct
  ]
  response_templates = {
    "application/json" = ""
  }
}

#Deployment
resource "aws_api_gateway_deployment" "apideploy" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id

  triggers = {
    redeployment = sha1(jsonencode([
      aws_api_gateway_resource.product.id,
      aws_api_gateway_method.prodget.id,
      aws_api_gateway_integration.getproduct.id,
    ]))
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_api_gateway_stage" "mystage" {
  deployment_id = aws_api_gateway_deployment.apideploy.id
  rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
  stage_name    = "prod"
}
#Permission

resource "aws_lambda_permission" "HealthPermission" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.Lambda.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/prod/GET/health"
                  
}

resource "aws_lambda_permission" "getPermission" {
   statement_id  = "AllowgetExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.Lambda.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/prod/GET/product"
                  
}
resource "aws_lambda_permission" "postPermission" {
   statement_id  = "AllowpostExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.Lambda.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/prod/POST/product"
                  
}

resource "aws_lambda_permission" "deletePermission" {
   statement_id  = "AllowdeleteExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.Lambda.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/prod/DELETE/product"
                  
}

output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}