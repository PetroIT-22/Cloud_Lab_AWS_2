module "labels" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  context     = var.context
  name        = var.name
  label_order = var.label_order
}
/*
resource "aws_iam_role" "iam_for_ci_cd" {
  name = "${module.labels.id}_for_ci_cd"

    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "s3:*",
      "Principal": {
        "Service": "s3.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
  EOF
}

resource "aws_iam_role_policy" "get_ci_cd" {
  name = module.labels.id
  role = aws_iam_role.iam_for_ci_cd.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "*",
            "Resource": "*"
        }
    ]
  })
}
*/
resource "aws_iam_role" "iam_for_get_all_authors" {
  name = "${module.labels.id}_for_get_all_authors"

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

resource "aws_iam_role_policy" "get_all_authors_policy" {
  name = module.labels.id
  role = aws_iam_role.iam_for_get_all_authors.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:Scan",
            "Resource": [var.dynamo_db_authors_arn]
        }
    ]
  })
}
#[var.dynamo_db_authors_arn, var.dynamo_db_courses_arn]

resource "aws_iam_role" "iam_for_get_all_courses" {
  name = "${module.labels.id}_for_get_all_courses"

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

resource "aws_iam_role_policy" "get_all_courses_policy" {
  name = module.labels.id
  role = aws_iam_role.iam_for_get_all_courses.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:Scan",
            "Resource": [var.dynamo_db_courses_arn]
        }
    ]
  })
}
#[var.dynamo_db_authors_arn, var.dynamo_db_courses_arn]

resource "aws_iam_role" "iam_for_get_course" {
  name = "${module.labels.id}_for_get_course"

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

resource "aws_iam_role_policy" "get_course_policy" {
  name = module.labels.id
  role = aws_iam_role.iam_for_get_course.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:GetItem",
            "Resource": [var.dynamo_db_courses_arn]
        }
    ]
  })
}
#[var.dynamo_db_authors_arn, var.dynamo_db_courses_arn]

resource "aws_iam_role" "iam_for_save_update_course" {
  name = "${module.labels.id}_for_save_update_course"

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

resource "aws_iam_role_policy" "save_update_course_policy" {
  name = module.labels.id
  role = aws_iam_role.iam_for_save_update_course.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:PutItem",
            "Resource": [var.dynamo_db_courses_arn]
        }
    ]
  })
}
#[var.dynamo_db_authors_arn, var.dynamo_db_courses_arn]

resource "aws_iam_role" "iam_for_delete_course" {
  name = "${module.labels.id}_for_delete_course"

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

resource "aws_iam_role_policy" "delete_course_policy" {
  name = module.labels.id
  role = aws_iam_role.iam_for_delete_course.id

  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": "arn:aws:logs:*:*:*"
        },
        {
            "Effect": "Allow",
            "Action": "dynamodb:DeleteItem",
            "Resource": [var.dynamo_db_courses_arn]
        }
    ]
  })
}