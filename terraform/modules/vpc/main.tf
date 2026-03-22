resource "aws_vpc" "main" {
  cidr_block           = var.cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true
}

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "public_one" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_one_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "public_two" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = local.public_subnet_two_cidr_block
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]
}

resource "aws_subnet" "private_one" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_one_cidr_block
  availability_zone = data.aws_availability_zones.available.names[0]
}

resource "aws_subnet" "private_two" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = local.private_subnet_two_cidr_block
  availability_zone = data.aws_availability_zones.available.names[1]
}

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }
}

resource "aws_route_table_association" "public_subnet_one_route" {
  subnet_id      = aws_subnet.public_one.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_subnet_two_route" {
  subnet_id      = aws_subnet.public_two.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table" "private_route_table" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table_association" "private_subnet_one_route" {
  subnet_id      = aws_subnet.private_one.id
  route_table_id = aws_route_table.private_route_table.id
}

resource "aws_route_table_association" "private_subnet_two_route" {
  subnet_id      = aws_subnet.private_two.id
  route_table_id = aws_route_table.private_route_table.id
}