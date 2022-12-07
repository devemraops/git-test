resource "aws_vpc" "eks" {
  cidr_block = "10.0.0.0/16"

  # makes your instances shared on the host.data
  instance_tenancy = "default"

  # Required for EKS. Enables/disable DNS support in the VPC.
  enable_dns_support = true

  # Required for EKS. Enable/disable DNS hostnames in the VPC.
  enable_dns_hostnames = true

  tags = {
    Name = "eks"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.eks.id

  tags = {
    Name = "eks"
  }
}

resource "aws_subnet" "eks-public1" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.101.0/24"
  availability_zone = "us-east-1a"
  # Required for EKS. Intances launched into the subnet should be assigned public IP.
  map_public_ip_on_launch = true
  tags = {
    Name = "public-us-east-1a"
    # Required for EKS 
    "kubernetes.io/cluster/${var.env}-${var.application}" = "shared" # it will allow EKS cluster to discover this particular subnets
    "kubernetes.io/role/elb"          = 1        # it will allow EKS to discover subnets and place in LB.
  }
}

resource "aws_subnet" "eks-public2" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.102.0/24"
  availability_zone = "us-east-1b"
  # Required for EKS. Intances launched into the subnet should be assigned public IP.
  map_public_ip_on_launch = true
  tags = {
    Name = "public-us-east-1b"
    # Required for EKS 
    "kubernetes.io/cluster/${var.env}-${var.application}" = "shared" # it will allow EKS cluster to discover this particular subnets
    "kubernetes.io/role/elb"          = 1        # it will allow EKS to discover subnets and place in LB.
  }
}

resource "aws_subnet" "eks-private1" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.103.0/24"
  availability_zone = "us-east-1a"
  # Required for EKS. Intances launched into the subnet should be assigned public IP.
  map_public_ip_on_launch = false
  tags = {
    Name = "private-us-east-1a"
    # Required for EKS 
    "kubernetes.io/cluster/${var.env}-${var.application}" = "shared" # it will allow EKS cluster to discover this particular subnets
    "kubernetes.io/role/internal-elb" = 1        # it will allow EKS to discover subnets and place in LB.
  }
}

resource "aws_subnet" "eks-private3" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.105.0/24"
  availability_zone = "us-east-1a"
  # Required for EKS. Intances launched into the subnet should be assigned public IP.
  map_public_ip_on_launch = false
  tags = {
    Name = "private-us-east-1c"
    # Required for EKS 
    "kubernetes.io/cluster/${var.env}-${var.application}" = "shared" # it will allow EKS cluster to discover this particular subnets
    "kubernetes.io/role/internal-elb" = 1        # it will allow EKS to discover subnets and place in LB.
  }
}

resource "aws_subnet" "eks-private2" {
  vpc_id            = aws_vpc.eks.id
  cidr_block        = "10.0.104.0/24"
  availability_zone = "us-east-1b"
  # Required for EKS. Intances launched into the subnet should be assigned public IP.
  map_public_ip_on_launch = true
  tags = {
    Name = "private-us-east-1b"
    # Required for EKS 
    "kubernetes.io/cluster/${var.env}-${var.application}" = "shared" # it will allow EKS cluster to discover this particular subnets
    "kubernetes.io/role/internal-elb" = 1        # it will allow EKS to discover subnets and place in LB.
  }
}

# Route tables

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "public"
  }
}

resource "aws_route_table" "private1" {
  vpc_id = aws_vpc.eks.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gate.id
  }

  tags = {
    Name = "private1"
  }
}

# route tables associations

resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.eks-public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.eks-public2.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.eks-private1.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.eks-private2.id
  route_table_id = aws_route_table.private1.id
}

resource "aws_route_table_association" "private3" {
  subnet_id      = aws_subnet.eks-private3.id
  route_table_id = aws_route_table.private1.id
}



