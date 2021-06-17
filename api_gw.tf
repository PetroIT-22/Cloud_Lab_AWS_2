resource "aws_api_gateway_rest_api" "this" {
  name                     = module.base_labels.id
  # description              = var.description
  binary_media_types       = ["UTF-8-encoded"]
  minimum_compression_size = -1
  api_key_source           = "HEADER"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
  policy = null
}

resource "aws_api_gateway_gateway_response" "this" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  status_code   = "404"
  response_type = "UNAUTHORIZED"

  response_templates = {
    "application/json" = "{\"message\":$context.error.messageString}"
  }

  # response_parameters = {
  #   "gatewayresponse.header.Authorization" = "'Basic'"
  # }
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id

  triggers = {
    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.this.body))
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.this.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
  stage_name    = "dev"
}

resource "aws_api_gateway_model" "this" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "test"
  content_type = "application/json"

  schema = <<EOF
{"type":"object"}
EOF
}

# resource "aws_api_gateway_api_key" "this" {
#   name        = "test"
# }

# resource "aws_api_gateway_client_certificate" "default" {
#   description = "clouddrove"
# }



resource "aws_api_gateway_resource" "authors" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "authors"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_authors" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.authors.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "get_authors" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.authors.id
  http_method             = aws_api_gateway_method.get_authors.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.get_all_authors_invoke_arn
  request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
  request_templates       = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_authors" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.authors.id
  http_method     = aws_api_gateway_method.get_authors.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "get_authors" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.authors.id
  http_method = aws_api_gateway_method.get_authors.http_method
  status_code = aws_api_gateway_method_response.get_authors.status_code

  # # Transforms the backend JSON response to XML
  # response_templates = {
  #   "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  # }
  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method" "options_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = aws_api_gateway_method.options_authors.http_method
  status_code   = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = false
    "method.response.header.Access-Control-Allow-Headers"     = false
    "method.response.header.Access-Control-Allow-Methods"     = false
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
  depends_on = [aws_api_gateway_method.options_authors]
}

resource "aws_api_gateway_integration" "options_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = aws_api_gateway_method.options_authors.http_method
  type          = "MOCK"
  depends_on = [aws_api_gateway_method.options_authors]
}

resource "aws_api_gateway_integration_response" "options_authors" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.authors.id
  http_method   = aws_api_gateway_method.options_authors.http_method
  status_code   = aws_api_gateway_method_response.options_authors.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_authors]
}














resource "aws_api_gateway_resource" "courses" {
  parent_id   = aws_api_gateway_rest_api.this.root_resource_id
  path_part   = "courses"
  rest_api_id = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_method" "get_courses" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.courses.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "get_courses" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.get_courses.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.get_all_courses_invoke_arn
  request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
  request_templates       = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "get_courses" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.get_courses.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "get_courses" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.get_courses.http_method
  status_code = aws_api_gateway_method_response.get_courses.status_code

  # # Transforms the backend JSON response to XML
  # response_templates = {
  #   "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  # }
  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method" "options_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = aws_api_gateway_method.options_courses.http_method
  status_code   = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
  depends_on = [aws_api_gateway_method.options_courses]
}

resource "aws_api_gateway_integration" "options_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = aws_api_gateway_method.options_courses.http_method
  type          = "MOCK"
  depends_on = [aws_api_gateway_method.options_courses]
}

resource "aws_api_gateway_integration_response" "options_courses" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = aws_api_gateway_method.options_courses.http_method
  status_code   = aws_api_gateway_method_response.options_courses.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_courses]
}

resource "aws_api_gateway_model" "post_course" {
  rest_api_id  = aws_api_gateway_rest_api.this.id
  name         = "PostCourse"
  description  = "a JSON schema"
  content_type = "application/json"

  schema = <<EOF
{
  "$schema": "http://json-schema.org/schema#",
  "title": "CourseInputModel",
  "type": "object",
  "properties": {
    "title": {"type": "string"},
    "authorId": {"type": "string"},
    "length": {"type": "string"},
    "category": {"type": "string"}
  },
  "required": ["title", "authorId", "length", "category"]
}
EOF
}

resource "aws_api_gateway_method" "post_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.courses.id
  http_method   = "POST"
  authorization = "NONE"

  request_models = {
    "application/json" = aws_api_gateway_model.post_course.name
  }
}

resource "aws_api_gateway_integration" "post_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.courses.id
  http_method             = aws_api_gateway_method.post_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.save_course_invoke_arn
  #request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
  request_templates       = {
    "application/xml" = <<EOF
  {
     "body" : $input.json('$')
  }
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
}

resource "aws_api_gateway_method_response" "post_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.courses.id
  http_method     = aws_api_gateway_method.post_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "post_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.courses.id
  http_method = aws_api_gateway_method.post_course.http_method
  status_code = aws_api_gateway_method_response.post_course.status_code

  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_resource" "course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  parent_id   = aws_api_gateway_resource.courses.id
  path_part   = "{id}"
}

resource "aws_api_gateway_method" "options_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = "OPTIONS"
  authorization = "NONE"
}

resource "aws_api_gateway_method_response" "options_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = aws_api_gateway_method.options_course.http_method
  status_code   = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Origin"      = true
    "method.response.header.Access-Control-Allow-Headers"     = true
    "method.response.header.Access-Control-Allow-Methods"     = true
    "method.response.header.Access-Control-Allow-Credentials" = true
  }
  depends_on = [aws_api_gateway_method.options_course]
}

resource "aws_api_gateway_integration" "options_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = aws_api_gateway_method.options_course.http_method
  type          = "MOCK"
  depends_on = [aws_api_gateway_method.options_course]
}

resource "aws_api_gateway_integration_response" "options_course" {
  rest_api_id   = aws_api_gateway_rest_api.this.id
  resource_id   = aws_api_gateway_resource.course.id
  http_method   = aws_api_gateway_method.options_course.http_method
  status_code   = aws_api_gateway_method_response.options_course.status_code
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
  depends_on = [aws_api_gateway_method_response.options_course]
}











resource "aws_api_gateway_method" "put_course" {
  authorization = "NONE"
  http_method   = "PUT"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "put_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.put_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.update_course_invoke_arn
  #request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
#   request_templates       = {
#     "application/json" = <<EOF
# {
#   "id": $input.params('id'),
#   "title" : $input.json('$.title'),
#   "authorId" : $input.json('$.authorId'),
#   "length" : $input.json('$.length'),
#   "category" : $input.json('$.category'),
#   "watchHref" : $input.json('$.watchHref')
# }
#   EOF
#   }
  content_handling     = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method_response" "put_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.put_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "put_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.put_course.http_method
  status_code = aws_api_gateway_method_response.put_course.status_code

  # # Transforms the backend JSON response to XML
  # response_templates = {
  #   "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  # }
  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}




resource "aws_api_gateway_method" "get_course" {
  authorization = "NONE"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "get_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.get_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.get_course_invoke_arn
  request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
  request_templates       = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method_response" "get_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.get_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "get_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.get_course.http_method
  status_code = aws_api_gateway_method_response.get_course.status_code

  # # Transforms the backend JSON response to XML
  # response_templates = {
  #   "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  # }
  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}

resource "aws_api_gateway_method" "delete_course" {
  authorization = "NONE"
  http_method   = "DELETE"
  resource_id   = aws_api_gateway_resource.course.id
  rest_api_id   = aws_api_gateway_rest_api.this.id
}

resource "aws_api_gateway_integration" "delete_course" {
  rest_api_id             = aws_api_gateway_rest_api.this.id
  resource_id             = aws_api_gateway_resource.course.id
  http_method             = aws_api_gateway_method.delete_course.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = module.lambda.delete_course_invoke_arn
  request_parameters      = {"integration.request.header.X-Authorization" = "'static'"}
  request_templates       = {
    "application/json" = <<EOF
{
  "id": "$input.params('id')"
}
  EOF
  }
  content_handling = "CONVERT_TO_TEXT"
  passthrough_behavior = "WHEN_NO_TEMPLATES"
}

resource "aws_api_gateway_method_response" "delete_course" {
  rest_api_id     = aws_api_gateway_rest_api.this.id
  resource_id     = aws_api_gateway_resource.course.id
  http_method     = aws_api_gateway_method.delete_course.http_method
  status_code     = "200"
  response_models = { "application/json" = "Empty" }
  response_parameters = {
    "method.response.header.Access-Control-Allow-Headers" = true,
    "method.response.header.Access-Control-Allow-Methods" = true,
    "method.response.header.Access-Control-Allow-Origin" = false
  }
}

resource "aws_api_gateway_integration_response" "delete_course" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_resource.course.id
  http_method = aws_api_gateway_method.delete_course.http_method
  status_code = aws_api_gateway_method_response.delete_course.status_code

  # # Transforms the backend JSON response to XML
  # response_templates = {
  #   "application/xml" = <<EOF
  # {
  #    "body" : $input.json('$')
  # }
  # EOF
  # }
  response_parameters ={
    "method.response.header.Access-Control-Allow-Headers" = "'Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token'",
    "method.response.header.Access-Control-Allow-Methods" = "'GET,OPTIONS,POST,PUT'",
    "method.response.header.Access-Control-Allow-Origin" = "'*'"
  }
}