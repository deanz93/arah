variable "env"         { type = string }
variable "cidr_block"  { type = string; default = "10.0.0.0/16" }

locals {
  az_count = 2  # ap-southeast-1a, ap-southeast-1b
  azs      = ["ap-southeast-1a", "ap-southeast-1b"]
  tags     = { Project = "arah", Env = var.env, ManagedBy = "terraform" }
}

resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support   = true
  tags                 = merge(local.tags, { Name = "arah-${var.env}-vpc" })
}

# Public subnets (ALB, NAT gateways)
resource "aws_subnet" "public" {
  count                   = local.az_count
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.cidr_block, 8, count.index)
  availability_zone       = local.azs[count.index]
  map_public_ip_on_launch = true
  tags = merge(local.tags, {
    Name                     = "arah-${var.env}-public-${local.azs[count.index]}"
    "kubernetes.io/role/elb" = "1"
  })
}

# Private subnets (EKS nodes, RDS, ElastiCache)
resource "aws_subnet" "private" {
  count             = local.az_count
  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.cidr_block, 8, count.index + 10)
  availability_zone = local.azs[count.index]
  tags = merge(local.tags, {
    Name                              = "arah-${var.env}-private-${local.azs[count.index]}"
    "kubernetes.io/role/internal-elb" = "1"
  })
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags   = merge(local.tags, { Name = "arah-${var.env}-igw" })
}

resource "aws_eip" "nat" {
  count  = 1  # Single NAT to save cost; use count=az_count for HA
  domain = "vpc"
  tags   = merge(local.tags, { Name = "arah-${var.env}-nat-eip-${count.index}" })
}

resource "aws_nat_gateway" "nat" {
  count         = 1
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[0].id
  tags          = merge(local.tags, { Name = "arah-${var.env}-nat-${count.index}" })
  depends_on    = [aws_internet_gateway.igw]
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = merge(local.tags, { Name = "arah-${var.env}-public-rt" })
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[0].id
  }
  tags = merge(local.tags, { Name = "arah-${var.env}-private-rt" })
}

resource "aws_route_table_association" "public" {
  count          = local.az_count
  subnet_id      = aws_subnet.public[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private" {
  count          = local.az_count
  subnet_id      = aws_subnet.private[count.index].id
  route_table_id = aws_route_table.private.id
}

output "vpc_id"             { value = aws_vpc.main.id }
output "public_subnet_ids"  { value = aws_subnet.public[*].id }
output "private_subnet_ids" { value = aws_subnet.private[*].id }
