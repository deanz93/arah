variable "env"                { type = string }
variable "vpc_id"             { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "node_type"          { type = string; default = "cache.t4g.small" }

locals {
  tags = { Project = "arah", Env = var.env, ManagedBy = "terraform" }
}

resource "aws_security_group" "redis" {
  name        = "arah-${var.env}-redis-sg"
  description = "Redis ElastiCache"
  vpc_id      = var.vpc_id

  ingress {
    description = "Redis from EKS nodes"
    from_port   = 6379
    to_port     = 6379
    protocol    = "tcp"
    cidr_blocks = ["10.0.0.0/16"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.tags, { Name = "arah-${var.env}-redis-sg" })
}

resource "aws_elasticache_subnet_group" "main" {
  name       = "arah-${var.env}-redis-subnet"
  subnet_ids = var.private_subnet_ids
  tags       = local.tags
}

resource "aws_elasticache_replication_group" "redis" {
  replication_group_id = "arah-${var.env}-redis"
  description          = "Arah ${var.env} Redis cache"
  node_type            = var.node_type
  port                 = 6379
  num_cache_clusters   = var.env == "production" ? 2 : 1

  subnet_group_name  = aws_elasticache_subnet_group.main.name
  security_group_ids = [aws_security_group.redis.id]

  at_rest_encryption_enabled = true
  transit_encryption_enabled = false  # Internal VPC only — no TLS overhead

  automatic_failover_enabled = var.env == "production" ? true : false

  parameter_group_name = "default.redis7"
  engine_version       = "7.1"

  # Evict least-recently-used keys when memory full
  # Configured in redis deployment.yaml also — this is the ElastiCache level
  tags = merge(local.tags, { Name = "arah-${var.env}-redis" })
}

output "redis_primary_endpoint" {
  value     = aws_elasticache_replication_group.redis.primary_endpoint_address
  sensitive = true
}
