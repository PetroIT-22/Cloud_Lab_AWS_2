variable "role_get_all_authors_arn" {
  description = "role_get_all_authors_arn"
  type        = string
}

variable "role_get_all_courses_arn" {
  description = "role_get_all_courses_arn"
  type        = string
}

variable "role_get_course_arn" {
  description = "role_get_course_arn"
  type        = string
}

variable "role_save_update_course_arn" {
  description = "role_save_update_course_arn"
  type        = string
}

variable "role_delete_course_arn" {
  description = "role_delete_course_arn"
  type        = string
}


variable "dynamo_db_authors_name" {
  description = "dynamo_db_authors_name"
  type        = string
}

variable "dynamo_db_courses_name" {
  description = "dynamo_db_courses_name"
  type        = string
}

variable "api_geteway_execution_arn" {
  description = "api_geteway_execution_arn"
  type        = string
}