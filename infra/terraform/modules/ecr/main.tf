variable "env"      { type = string }
variable "services" {
  type    = list(string)
  default = ["api-gateway", "tile-server"]
}

locals {
  tags = { Project = "arah", Env = var.env, ManagedBy = "terraform" }
}

resource "aws_ecr_repository" "services" {
  for_each             = toset(var.services)
  name                 = "arah/${each.value}"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration { scan_on_push = true }
  encryption_configuration     { encryption_type = "AES256" }
  tags                         = merge(local.tags, { Name = "arah/${each.value}" })
}

# Keep last 10 images, delete untagged after 1 day
resource "aws_ecr_lifecycle_policy" "cleanup" {
  for_each   = aws_ecr_repository.services
  repository = each.value.name
  policy = jsonencode({
    rules = [
      {
        rulePriority = 1
        description  = "Remove untagged images after 1 day"
        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = 1
        }
        action = { type = "expire" }
      },
      {
        rulePriority = 2
        description  = "Keep last 10 tagged images"
        selection = {
          tagStatus     = "tagged"
          tagPrefixList = ["v"]
          countType     = "imageCountMoreThan"
          countNumber   = 10
        }
        action = { type = "expire" }
      }
    ]
  })
}

output "repository_urls" {
  value = { for k, v in aws_ecr_repository.services : k => v.repository_url }
}
