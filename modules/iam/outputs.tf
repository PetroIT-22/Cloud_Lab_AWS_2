output "role_get_all_authors_arn" {
  value = aws_iam_role.iam_for_get_all_authors.arn
}

output "role_get_all_courses_arn" {
  value = aws_iam_role.iam_for_get_all_courses.arn
}

output "role_get_course_arn" {
  value = aws_iam_role.iam_for_get_course.arn
}

output "role_save_update_course_arn" {
  value = aws_iam_role.iam_for_save_update_course.arn
}

output "role_delete_course_arn" {
  value = aws_iam_role.iam_for_delete_course.arn
}