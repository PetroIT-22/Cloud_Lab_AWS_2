output "role_dynamodb_arn" {
  value =  aws_dynamodb_table.this.arn
}
output "role_dynamodb_name" {
  value =  aws_dynamodb_table.this.name
}
output "role_dynamodb_hash_key" {
  value =  aws_dynamodb_table.this.hash_key
}