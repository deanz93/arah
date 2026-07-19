variable "env"                { type = string }
variable "vpc_id"             { type = string }
variable "private_subnet_ids" { type = list(string) }
variable "k8s_version"        { type = string; default = "1.30" }

locals {
  cluster_name = "arah-${var.env}"
  tags         = { Project = "arah", Env = var.env, ManagedBy = "terraform" }
}

# ── IAM ───────────────────────────────────────────────────────────
resource "aws_iam_role" "cluster" {
  name = "arah-${var.env}-eks-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
    }]
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "node" {
  name = "arah-${var.env}-eks-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
    }]
  })
  tags = local.tags
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
  ])
  policy_arn = each.value
  role       = aws_iam_role.node.name
}

# ── Security Groups ───────────────────────────────────────────────
resource "aws_security_group" "cluster" {
  name        = "arah-${var.env}-eks-cluster-sg"
  description = "EKS cluster control plane"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = merge(local.tags, { Name = "arah-${var.env}-eks-cluster-sg" })
}

# ── EKS Cluster ───────────────────────────────────────────────────
resource "aws_eks_cluster" "main" {
  name     = local.cluster_name
  version  = var.k8s_version
  role_arn = aws_iam_role.cluster.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    security_group_ids      = [aws_security_group.cluster.id]
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  enabled_cluster_log_types = ["api", "audit", "controllerManager", "scheduler"]
  tags                      = merge(local.tags, { Name = local.cluster_name })
  depends_on                = [aws_iam_role_policy_attachment.cluster_policy]
}

# ── Node Groups ───────────────────────────────────────────────────
# General purpose nodes (API Gateway, Redis, Tile Server, Web)
resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "arah-${var.env}-general"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.env == "production" ? ["m5.large"] : ["t3.medium"]
  ami_type        = "AL2_x86_64"

  scaling_config {
    desired_size = var.env == "production" ? 2 : 1
    min_size     = 1
    max_size     = var.env == "production" ? 6 : 2
  }

  update_config { max_unavailable = 1 }

  labels = { "node-type" = "general" }
  tags   = merge(local.tags, { Name = "arah-${var.env}-general-node" })
  depends_on = [aws_iam_role_policy_attachment.node_policies]
}

# Memory-optimised nodes (Valhalla routing — 4GB RAM per pod)
resource "aws_eks_node_group" "memory" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "arah-${var.env}-memory"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.env == "production" ? ["r6i.xlarge"] : ["r6i.large"]
  ami_type        = "AL2_x86_64"

  scaling_config {
    desired_size = var.env == "production" ? 2 : 1
    min_size     = 1
    max_size     = var.env == "production" ? 6 : 2
  }

  update_config { max_unavailable = 1 }

  labels = { "node-type" = "memory-optimized" }

  taint {
    key    = "node-type"
    value  = "memory-optimized"
    effect = "NO_SCHEDULE"
  }

  tags       = merge(local.tags, { Name = "arah-${var.env}-memory-node" })
  depends_on = [aws_iam_role_policy_attachment.node_policies]
}

# ── OIDC Provider (for IAM roles for service accounts) ────────────
data "tls_certificate" "eks" {
  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks.certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
  tags            = local.tags
}

output "cluster_name"              { value = aws_eks_cluster.main.name }
output "cluster_endpoint"          { value = aws_eks_cluster.main.endpoint }
output "cluster_ca_certificate"    { value = aws_eks_cluster.main.certificate_authority[0].data }
output "oidc_provider_arn"         { value = aws_iam_openid_connect_provider.eks.arn }
output "node_role_arn"             { value = aws_iam_role.node.arn }
