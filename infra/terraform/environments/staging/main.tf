terraform {
  required_version = ">= 1.9"

  required_providers {
    aws        = { source = "hashicorp/aws",        version = "~> 5.60" }
    kubernetes = { source = "hashicorp/kubernetes",  version = "~> 2.31" }
    helm       = { source = "hashicorp/helm",        version = "~> 2.14" }
  }

  backend "s3" {
    bucket         = "arah-terraform-state"
    key            = "staging/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "arah-terraform-locks"
    encrypt        = true
  }
}

provider "aws" {
  region = "ap-southeast-1"
  default_tags { tags = { Project = "arah", Env = "staging", ManagedBy = "terraform" } }
}

# ── Modules ───────────────────────────────────────────────────────────────────

module "vpc" {
  source = "../../modules/vpc"
  env    = "staging"
}

module "eks" {
  source             = "../../modules/eks"
  env                = "staging"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
}

module "ecr" {
  source = "../../modules/ecr"
  env    = "staging"
}

module "elasticache" {
  source             = "../../modules/elasticache"
  env                = "staging"
  vpc_id             = module.vpc.vpc_id
  private_subnet_ids = module.vpc.private_subnet_ids
  node_type          = "cache.t4g.small"
}

module "cloudfront" {
  source          = "../../modules/cloudfront"
  env             = "staging"
  tile_origin_url = "placeholder"  # Set after first EKS deploy
}

# ── Kubernetes provider (reads from EKS after cluster exists) ─────────────────
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
}

# ── Helm: nginx ingress controller ────────────────────────────────────────────
resource "helm_release" "nginx_ingress" {
  name             = "nginx-ingress"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.11.0"
  namespace        = "ingress-nginx"
  create_namespace = true

  values = [file("${path.module}/helm-values/nginx-ingress.yaml")]
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

# ── Outputs ───────────────────────────────────────────────────────────────────
output "cluster_name"       { value = module.eks.cluster_name }
output "cluster_endpoint"   { value = module.eks.cluster_endpoint }
output "ecr_urls"           { value = module.ecr.repository_urls }
output "redis_endpoint"     { value = module.elasticache.redis_primary_endpoint; sensitive = true }
output "tiles_cdn_domain"   { value = module.cloudfront.tiles_cdn_domain }
output "tiles_bucket_name"  { value = module.cloudfront.tiles_bucket_name }
