variable "region" {
  type = string
}

variable "website_cloudfront_min_ttl" {
  type    = number
  default = 0
}

variable "website_cloudfront_default_ttl" {
  type    = number
  default = 0
}

variable "website_cloudfront_max_ttl" {
  type    = number
  default = 0
}

variable "alarm_emails" {
  type    = set(string)
}
variable "subscriber_email_addresses" {
  type    = list(string)
}

variable "slack_webhook_url" {
  type    = string
}

variable "author_name" {
  type    = string
}
