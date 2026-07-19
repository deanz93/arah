variable "env"              { type = string }
variable "domain"            { type = string; default = "arah.my" }
variable "alb_dns_name"      { type = string }
variable "alb_zone_id"       { type = string }
variable "tiles_cdn_domain"  { type = string }

locals {
  # Staging uses a subdomain prefix; production uses the apex
  zone_name = var.env == "production" ? var.domain : "${var.env}.${var.domain}"
  tags      = { Project = "arah", Env = var.env, ManagedBy = "terraform" }
}

# The hosted zone is expected to already exist (managed per domain, not per env)
data "aws_route53_zone" "main" {
  name         = var.domain
  private_zone = false
}

# API Gateway: api.arah.my (prod) / api.staging.arah.my (staging)
resource "aws_route53_record" "api" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.env == "production" ? "api.${var.domain}" : "api.${var.env}.${var.domain}"
  type    = "A"

  alias {
    name                   = var.alb_dns_name
    zone_id                = var.alb_zone_id
    evaluate_target_health = true
  }
}

# Tile CDN: tiles.arah.my (prod) / tiles.staging.arah.my (staging)
resource "aws_route53_record" "tiles" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = var.env == "production" ? "tiles.${var.domain}" : "tiles.${var.env}.${var.domain}"
  type    = "CNAME"
  ttl     = 300
  records = [var.tiles_cdn_domain]
}

# Health check for API endpoint
resource "aws_route53_health_check" "api" {
  fqdn              = var.env == "production" ? "api.${var.domain}" : "api.${var.env}.${var.domain}"
  port              = 443
  type              = "HTTPS"
  resource_path     = "/health"
  failure_threshold = 3
  request_interval  = 30
  tags              = merge(local.tags, { Name = "arah-${var.env}-api-health" })
}

output "api_fqdn"    { value = aws_route53_record.api.name }
output "tiles_fqdn"  { value = aws_route53_record.tiles.name }
output "health_check_id" { value = aws_route53_health_check.api.id }
