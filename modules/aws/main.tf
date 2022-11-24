data "aws_caller_identity" "current" {}

resource "aws_cloudfront_origin_access_control" "default" {
  name                              = "${var.project_name}-${var.environment}"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket" "bucket" {
  bucket = "${var.project_name}-${var.environment}"
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.bucket.id
  acl    = "private"
}

resource "aws_s3_bucket_cors_configuration" "bucket_cors" {
  bucket = aws_s3_bucket.bucket.id

  cors_rule {
    allowed_headers = ["*"]
    allowed_methods = ["PUT"]
    allowed_origins = var.cors_origins
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
}

data "aws_iam_policy_document" "s3_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = [aws_cloudfront_origin_access_identity.identity.iam_arn]
    }
  }
}

resource "aws_s3_bucket_policy" "mybucket" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_policy.json
}


locals {
  s3_origin_id = "${var.project_name}-${var.environment}-s3-origin"
}

resource "aws_cloudfront_origin_access_identity" "identity" {
  comment = "s3 identity"
}


resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
    origin_id   = local.s3_origin_id

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = true

  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = local.s3_origin_id

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_100"

  tags = {
    environment = var.environment
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

resource "aws_cognito_user_pool" "user_pool" {
  name                     = "${var.project_name}-${var.environment}"
  auto_verified_attributes = ["email"]

  lambda_config {
    pre_sign_up          = "arn:aws:lambda:eu-central-1:${data.aws_caller_identity.current.account_id}:function:cognito-${var.environment}-preSignUp"
    pre_token_generation = "arn:aws:lambda:eu-central-1:${data.aws_caller_identity.current.account_id}:function:cognito-${var.environment}-preTokenGeneration"
  }
}

resource "aws_cognito_user_pool_client" "web_client" {
  name = "web"

  user_pool_id                 = aws_cognito_user_pool.user_pool.id
  supported_identity_providers = ["COGNITO"]
}

resource "aws_cognito_user_pool_client" "native_client" {
  name = "native"

  user_pool_id                 = aws_cognito_user_pool.user_pool.id
  supported_identity_providers = ["COGNITO"]
}

resource "aws_lambda_permission" "allow_pre_signup_execution_from_user_pool" {
  statement_id  = "AllowExecutionFromUserPool"
  action        = "lambda:InvokeFunction"
  function_name = "cognito-${var.environment}-preSignUp"
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user_pool.arn
}

resource "aws_lambda_permission" "allow_pre_token_generation_execution_from_user_pool" {
  statement_id  = "AllowExecutionFromUserPool"
  action        = "lambda:InvokeFunction"
  function_name = "cognito-${var.environment}-preTokenGeneration"
  principal     = "cognito-idp.amazonaws.com"
  source_arn    = aws_cognito_user_pool.user_pool.arn
}
