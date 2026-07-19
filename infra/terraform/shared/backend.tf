terraform {
  required_version = ">= 1.9.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.60"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.31"
    }
    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.14"
    }
  }

  # Remote state in S3 — one bucket, separate keys per environment
  # Bootstrap: `aws s3 mb s3://arah-terraform-state --region ap-southeast-1`
  #            `aws dynamodb create-table --table-name arah-terraform-locks \`
  #             `--attribute-definitions AttributeName=LockID,AttributeType=S \`
  #             `--key-schema AttributeName=LockID,KeyType=HASH \`
  #             `--billing-mode PAY_PER_REQUEST --region ap-southeast-1`
  backend "s3" {
    bucket         = "arah-terraform-state"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "arah-terraform-locks"
    # key is set per environment: environments/staging/main.tf or environments/production/main.tf
  }
}
