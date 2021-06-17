variable "domain_name" {
  type        = string
  description = "Domain name"
}
/* 
variable "zone_id" {
  type        = string
  description = "Route53 zone id"
} */

variable "website_cloudfront_min_ttl" {
  type        = number
  description = "min_ttl"
}

variable "website_cloudfront_default_ttl" {
  type        = number
  description = "default_ttl"
}

variable "website_cloudfront_max_ttl" {
  type        = number
  description = "max_ttl"
}