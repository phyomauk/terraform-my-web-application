data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  azs = slice(sort(data.aws_availability_zones.available.names), 0, 2)
}


#######################################
# VPC
#######################################
resource "aws_vpc" "main" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.project_name}-vpc"
  }
}

#######################################
# Internet Gateway
#######################################
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-igw"
  }
}

###########################################
# Subnets 
###########################################

# Public subnets (2 AZs)
resource "aws_subnet" "public" {
  for_each = {
    for idx, az in local.azs :
    az => idx
  }

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone       = each.key
  map_public_ip_on_launch = true

  tags = {
    Name = "public-${each.key}"
  }
}

# Private subnets (2 AZs)
resource "aws_subnet" "private" {
  for_each = {
    for idx, az in local.azs :
    az => idx + 10
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = each.key

  tags = {
    Name = "private-${each.key}"
  }
}

# DocumentDB subnets
resource "aws_subnet" "docdb" {
  for_each = {
    for idx, az in local.azs :
    az => idx + 20
  }

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, each.value)
  availability_zone = each.key

  tags = {
    Name = "docdb-${each.key}"
  }
}

#####################################
# Public route table
#####################################
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = "${var.project_name}-public-rt"
  }
}

resource "aws_route_table_association" "public_assoc" {
  for_each       = aws_subnet.public
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public.id
}

#####################################
# Private route table
#####################################
resource "aws_route_table" "private" {
  for_each = aws_subnet.private
  vpc_id   = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat.id
  }

  tags = {
    Name = "${var.project_name}-private-rt-${each.key}"
  }
}

resource "aws_route_table_association" "private_assoc" {
  for_each       = aws_subnet.private
  subnet_id      = each.value.id
  route_table_id = aws_route_table.private[each.key].id
}

###########################################
# DocDB Route Tables & Associations
###########################################
# Isolated Route Table for DocumentDB (Internal VPC traffic only, no internet routes)
resource "aws_route_table" "docdb" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.project_name}-docdb-rt"
  }
}

resource "aws_route_table_association" "docdb" {
  for_each       = aws_subnet.docdb
  subnet_id      = each.value.id
  route_table_id = aws_route_table.docdb.id
}

###########################################
# NAT
###########################################
# NAT gateways in public subnets
resource "aws_eip" "nat_eip" {
  tags = {
    Name = "${var.project_name}-nat-eip"
  }
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = tolist(values(aws_subnet.public))[0].id

  tags = {
    Name = "${var.project_name}-nat"
  }

}
