# VPC Section
resource "aws_vpc" "ecs_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name    = "ecs-vpc"
    Project = "ecs"
  }
}
# IGW Section
resource "aws_internet_gateway" "ecs_igw" {
  vpc_id = aws_vpc.ecs_vpc.id
  tags = {
    Name    = "ecs-igw"
    Project = "ecs"
  }
}
# Subnet Section
resource "aws_subnet" "ecs_subnet_public_2a" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name    = "ecs-subnet-public-eu-west-2a"
    Project = "ecs"
  }
}
resource "aws_subnet" "ecs_subnet_private_2a" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.11.0/24"
  availability_zone = "eu-west-2a"

  tags = {
    Name    = "ecs-subnet-private-eu-west-2a"
    Project = "ecs"
  }
}
resource "aws_subnet" "ecs_subnet_public_2b" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "eu-west-2b"

  tags = {
    Name    = "ecs-subnet-public-eu-west-2b"
    Project = "ecs"
  }
}
resource "aws_subnet" "ecs_subnet_private_2b" {
  vpc_id            = aws_vpc.ecs_vpc.id
  cidr_block        = "10.0.12.0/24"
  availability_zone = "eu-west-2b"


  tags = {
    Name    = "ecs-subnet-private-eu-west-2b"
    Project = "ecs"
  }
}
# Regional NAT Gateway Section
resource "aws_nat_gateway" "ecs_nat" {
  vpc_id            = aws_vpc.ecs_vpc.id
  availability_mode = "regional"
  depends_on        = [aws_internet_gateway.ecs_igw]

  tags = {
    Name    = "ecs-regional-nat"
    Project = "ecs"
  }
}
# Route Tables Section
resource "aws_route_table" "ecs_rtb_public" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.ecs_igw.id
  }

  tags = {
    Name    = "ecs-rtb-public"
    Project = "ecs"
  }
}

resource "aws_route_table" "ecs_rtb_private" {
  vpc_id = aws_vpc.ecs_vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ecs_nat.id
  }

  tags = {
    Name    = "ecs-rtb-private"
    Project = "ecs"
  }
}

# Route Table Associations
resource "aws_route_table_association" "ecs_rt_public_2a_association" {
  subnet_id      = aws_subnet.ecs_subnet_public_2a.id
  route_table_id = aws_route_table.ecs_rtb_public.id
}
resource "aws_route_table_association" "ecs_rt_public_2b_association" {
  subnet_id      = aws_subnet.ecs_subnet_public_2b.id
  route_table_id = aws_route_table.ecs_rtb_public.id
}
resource "aws_route_table_association" "ecs_rt_private_2a_association" {
  subnet_id      = aws_subnet.ecs_subnet_private_2a.id
  route_table_id = aws_route_table.ecs_rtb_private.id
}
resource "aws_route_table_association" "ecs_rt_private_2b_association" {
  subnet_id      = aws_subnet.ecs_subnet_private_2b.id
  route_table_id = aws_route_table.ecs_rtb_private.id
}
