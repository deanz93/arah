variable "env"             { type = string }
variable "tile_origin_url" { type = string }  # e.g. tile-server K8s service via ALB

locals {
  tags = { Project = "arah", Env = var.env, ManagedBy = "terraform" }
}

# S3 bucket for PMTiles storage (cheaper than EFS for static files)
resource "aws_s3_bucket" "tiles" {
  bucket = "arah-${var.env}-tiles"
  tags   = merge(local.tags, { Name = "arah-${var.env}-tiles" })
}

resource "aws_s3_bucket_versioning" "tiles" {
  bucket = aws_s3_bucket.tiles.id
  versioning_configuration { status = "Disabled" }
}

resource "aws_s3_bucket_public_access_block" "tiles" {
  bucket                  = aws_s3_bucket.tiles.id
  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# CloudFront Origin Access Control
resource "aws_cloudfront_origin_access_control" "tiles" {
  name                              = "arah-${var.env}-tiles-oac"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_s3_bucket_policy" "tiles" {
  bucket = aws_s3_bucket.tiles.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid    = "AllowCloudFront"
      Effect = "Allow"
      Principal = { Service = "cloudfront.amazonaws.com" }
      Action   = "s3:GetObject"
      Resource = "${aws_s3_bucket.tiles.arn}/*"
      Condition = {
        StringEquals = {
          "AWS:SourceArn" = aws_cloudfront_distribution.tiles.arn
        }
      }
    }]
  })
}

resource "aws_cloudfront_distribution" "tiles" {
  enabled         = true
  is_ipv6_enabled = true
  comment         = "Arah ${var.env} map tiles CDN"
  price_class     = "PriceClass_All"  # Global — include Asia Pacific

  origin {
    domain_name              = aws_s3_bucket.tiles.bucket_regional_domain_name
    origin_id                = "tiles-s3"
    origin_access_control_id = aws_cloudfront_origin_access_control.tiles.id
  }

  default_cache_behavior {
    allowed_methods        = ["GET", "HEAD", "OPTIONS"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "tiles-s3"
    viewer_protocol_policy = "redirect-to-https"
    compress               = true

    # Map tiles rarely change — cache aggressively
    min_ttl     = 0
    default_ttl = 604800   # 7 days
    max_ttl     = 2592000  # 30 days

    forwarded_values {
      query_string = false
      cookies { forward = "none" }
    }
  }

  restrictions {
    geo_restriction { restriction_type = "none" }
  }

  viewer_certificate {
    cloudfront_default_certificate = true
    # Set to acm_certificate_arn once custom domain is ready
  }

  tags = merge(local.tags, { Name = "arah-${var.env}-tiles-cdn" })
}

output "tiles_bucket_name"      { value = aws_s3_bucket.tiles.id }
output "tiles_cdn_domain"       { value = aws_cloudfront_distribution.tiles.domain_name }
output "tiles_cdn_id"           { value = aws_cloudfront_distribution.tiles.id }
