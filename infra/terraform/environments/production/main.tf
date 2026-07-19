terraform {
  required_version = ">= 1.9"

  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 5.60" }
    kubernetes = { source = "hashicorp/kubernetes",  version = "~> 2.31" }
    helm       = { source = "hashicorp/helm",        version = "~> 2.14" }
  }

  backend "s3" {
    bucket         = "arah-terraform-state"
    key            = "production/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "arah-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
  default_tags { tags = { Project = "arah", Env = "production", ManagedBy = "terraform" } }
}

# ── Modules ───────────────────────────────────────────────────────────────────

module "vpc" {
  source = "../../modules/vpc"
  env    = "production"
}

module "eks" {
  source             = "../../modules/eks"
  env                = "production"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  k8s_version        = "1.30"
}

module "ecr" {
  source = "../../modules/ecr"
  env    = "production"
}

module "elasticache" {
  source             = "../../modules/elasticache"
  env                = "production"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_type          = "cache.r7g.large"  # Bigger node for prod traffic
}

module "cloudfront" {
  source          = "../../modules/cloudfront"
  env             = "production"
  tile_origin_url = "placeholder"
}

# ── Kubernetes / Helm providers ───────────────────────────────────────────────
provider "kubernetes" {
  host                   = module.eks.cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
  }
}

provider "helm" {
  kubernetes {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_ca_certificate)

    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "aws"
      args        = ["eks", "get-token", "--cluster-name", module.eks.cluster_name]
    }
  }
}

# ── Helm: cert-manager ────────────────────────────────────────────────────────
resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  version          = "v1.15.0"
  namespace        = "cert-manager"
  create_namespace = true

  set { name = "installCRDs"; value = "true" }

  set { name = "replicaCount"; value = "2" }
}

# ── Helm: nginx ingress controller ────────────────────────────────────────────
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.0"
  namespace        = "ingress-nginx"
  create_namespace = true

  values     = [file("${path.module}/helm-values/nginx-ingress.yaml")]
  depends_on = [module.eks]
}

# ── Helm: kube-prometheus-stack ───────────────────────────────────────────────
resource "helm_release" "prometheus" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  version          = "61.7.0"
  namespace        = "monitoring"
  create_namespace = true

  values     = [file("${path.module}/helm-values/prometheus.yaml")]
  depends_on = [module.eks]
}

# ── Route53 (production only — staging uses subdomain, no ALB ARN yet) ────────
# Uncomment after first deploy when ALB ARN is known:
# module "route53" {
#   source           = "../../modules/route53"
#   env              = "production"
#   alb_dns_name     = data.kubernetes_service.nginx_lb.status[0].load_balancer[0].ingress[0].hostname
#   alb_zone_id      = "Z1LMS91P8CMLE5"  # ap-southeast-1 ALB zone ID
#   tiles_cdn_domain = module.cloudfront.tiles_cdn_domain
# }

# ── Outputs ───────────────────────────────────────────────────────────────────
output "cluster_name"       { value = module.eks.cluster_name }
output "cluster_endpoint"   { value = module.eks.cluster_endpoint }
output "ecr_urls"           { value = module.ecr.repository_urls }
output "redis_endpoint"     { value = module.elasticache.redis_primary_endpoint; sensitive = true }
output "tiles_cdn_domain"   { value = module.cloudfront.tiles_cdn_domain }
output "tiles_bucket_name"  { value = module.cloudfront.tiles_bucket_name }
output "oidc_provider_arn"  { value = module.eks.oidc_provider_arn }
