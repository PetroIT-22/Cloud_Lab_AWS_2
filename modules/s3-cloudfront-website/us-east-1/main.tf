locals {
  domain_name = module.labels.stage == "prod" ? var.domain_name : "${var.name}.${var.domain_name}"
}

/* data "aws_region" "current" {} */


module "labels" {
  source      = "git::https://github.com/cloudposse/terraform-null-label.git?ref=0.24.1"
  context     = var.context
  name        = var.name
  label_order = var.label_order
  environment = var.environment
}

resource "aws_s3_bucket" "this" {
  bucket = "${local.domain_name}-cloudfront"
  acl    = "private"
  /* region        = data.aws_region.current.name */
  force_destroy = true
  tags          = module.labels.tags
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.this.json
}

data "aws_iam_policy_document" "this" {
  statement {
    actions = [
      "s3:GetObject",
    ]
    resources = [
      "${aws_s3_bucket.this.arn}/*",
    ]
    principals {
      type = "AWS"
      identifiers = [
        aws_cloudfront_origin_access_identity.default.iam_arn,
      ]
    }
  }
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  wait_for_deployment = false
  price_class         = "PriceClass_100"
  default_root_object = "index.html"
  /* aliases = [
    local.domain_name,
  ] */

  default_cache_behavior {
    compress               = true
    target_origin_id       = var.name
    viewer_protocol_policy = "allow-all"

    min_ttl     = var.website_cloudfront_min_ttl
    default_ttl = var.website_cloudfront_default_ttl
    max_ttl     = var.website_cloudfront_max_ttl

    allowed_methods = [
      "DELETE",
      "GET",
      "HEAD",
      "OPTIONS",
      "PATCH",
      "POST",
      "PUT",
    ]

    cached_methods = [
      "GET",
      "HEAD",
    ]

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }

    }
  }

  origin {
    domain_name = aws_s3_bucket.this.bucket_domain_name
    origin_id   = var.name

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.default.cloudfront_access_identity_path
    }

  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  /* depends_on = [
    aws_acm_certificate_validation.this,
  ] */

  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "400"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "404"
    response_code         = "200"
    response_page_path    = "/index.html"
  }
  custom_error_response {
    error_caching_min_ttl = "0"
    error_code            = "403"
    response_code         = "200"
    response_page_path    = "/index.html"
  }

}

resource "aws_cloudfront_origin_access_identity" "default" {
  comment = module.labels.id
}

/* resource "aws_route53_record" "this" {
  zone_id = var.zone_id
  name    = local.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.this.domain_name
    zone_id                = aws_cloudfront_distribution.this.hosted_zone_id
    evaluate_target_health = false
  }

  depends_on = [
    aws_cloudfront_distribution.this,
  ]

} */

/* resource "aws_acm_certificate" "this" {
  domain_name       = local.domain_name
  validation_method = "DNS"
  tags              = module.labels.tags

  lifecycle {
    create_before_destroy = true
  }

} */
/* 
resource "aws_route53_record" "cert_validation" {
  name    = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_name
  type    = tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_type
  zone_id = var.zone_id
  ttl     = 60
  records = [
    tolist(aws_acm_certificate.this.domain_validation_options)[0].resource_record_value
  ]
}

resource "aws_acm_certificate_validation" "this" {
  certificate_arn = aws_acm_certificate.this.arn
  validation_record_fqdns = [
    aws_route53_record.cert_validation.fqdn,
  ]
  timeouts {
    create = "1m"
  }
} */
