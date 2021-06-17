module "labels" {
  source  = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  context = var.context
  name    = var.name
  label_order = var.label_order
}

data "archive_file" "get_all_authors" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/get-all-authors/get-all-authors.js"
  output_path = "modules/lambda/eu-central-1/lambda-functions/get-all-authors/get-all-authors.zip"
}

resource "aws_lambda_function" "get_all_authors" {
  filename      = data.archive_file.get_all_authors.output_path
  function_name = "${module.labels.id}-get-all-authors"
  role          = var.role_get_all_authors_arn
  handler       = "get-all-authors.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.get_all_authors.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_authors_name
    }
  }
}



data "archive_file" "get_all_courses" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/get-all-courses/get-all-courses.js"
  output_path = "modules/lambda/eu-central-1/lambda-functions/get-all-courses/get-all-courses.zip"
}

resource "aws_lambda_function" "get_all_courses" {
  filename      = data.archive_file.get_all_courses.output_path
  function_name = "${module.labels.id}-get-all-courses"
  role          = var.role_get_all_courses_arn
  handler       = "get-all-courses.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.get_all_courses.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_courses_name
    }
  }
}

data "archive_file" "get_course" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/get-course/get-course.js"
  output_path = "modules/lambda/eu-central-1/lambda-functions/get-course/get-course.zip"
}

resource "aws_lambda_function" "get_course" {
  filename      = data.archive_file.get_course.output_path
  function_name = "${module.labels.id}-get-course"
  role          = var.role_get_course_arn
  handler       = "get-course.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.get_course.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_courses_name
    }
  }
}

data "archive_file" "save_course" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/save-course/save-course.js"
  output_path = "modules/lambda/eu-central-1/lambda-functions/save-course/save-course.zip"
}

resource "aws_lambda_function" "save_course" {
  filename      = data.archive_file.save_course.output_path
  function_name = "${module.labels.id}-save-course"
  role          = var.role_save_update_course_arn
  handler       = "save-course.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.save_course.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_courses_name
    }
  }
}

data "archive_file" "update_course" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/update-course/update-course.js"
  output_path = "modules/lambda/eu-central-1/lambda-functions/update-course/update-course.zip"
}

resource "aws_lambda_function" "update_course" {
  filename      = data.archive_file.update_course.output_path
  function_name = "${module.labels.id}-update-course"
  role          = var.role_save_update_course_arn
  handler       = "update-course.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.update_course.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_courses_name
    }
  }
}

data "archive_file" "delete_course" {
  type        = "zip"
  source_file = "${path.module}/lambda-functions/delete-course/delete-course.js"
  output_path = "modules/lambda/eu-central-1/lambda-functions/delete-course/delete-course.zip"
}

resource "aws_lambda_function" "delete_course" {
  filename      = data.archive_file.delete_course.output_path
  function_name = "${module.labels.id}-delete-course"
  role          = var.role_delete_course_arn
  handler       = "delete-course.handler"

  #   # The filebase64sha256() function is available in Terraform 0.11.12 and later
  #   # For Terraform 0.11.11 and earlier, use the base64sha256() function and the file() function:
  #   # source_code_hash = "${base64sha256(file("lambda_function_payload.zip"))}"
  source_code_hash = data.archive_file.delete_course.output_base64sha256

  runtime = "nodejs14.x"
  environment {
    variables = {
      "TABLE_NAME" = var.dynamo_db_courses_name
    }
  }
}

resource "aws_lambda_permission" "get_all_authors_permission" {
  function_name = "${module.labels.id}-get-all-authors"
  statement_id  = module.labels.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_geteway_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "get_all_courses_permission" {
  function_name = "${module.labels.id}-get-all-courses"
  statement_id  = module.labels.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_geteway_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "get_course_permission" {
  function_name = "${module.labels.id}-get-course"
  statement_id  = module.labels.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_geteway_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "save_course_permission" {
  function_name = "${module.labels.id}-save-course"
  statement_id  = module.labels.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_geteway_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "update_course_permission" {
  function_name = "${module.labels.id}-update-course"
  statement_id  = module.labels.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_geteway_execution_arn}/*/*/*"
}

resource "aws_lambda_permission" "delete_course_permission" {
  function_name = "${module.labels.id}-delete-course"
  statement_id  = module.labels.id
  action        = "lambda:InvokeFunction"
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${var.api_geteway_execution_arn}/*/*/*"
}
