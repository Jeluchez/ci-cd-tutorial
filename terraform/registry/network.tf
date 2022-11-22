resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "public1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet1
  availability_zone       = "us-east-1b"
  map_public_ip_on_launch = true
}

resource "aws_subnet" "public2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnet2
  availability_zone       = "us-east-1c"
  map_public_ip_on_launch = true
}

# gateway for access to from internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# --------------------------- Asocciate route table with public route --------------------------- #

# create route table 
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public_route_1" {
  subnet_id      = aws_subnet.public1.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_route_2" {
  subnet_id      = aws_subnet.public2.id
  route_table_id = aws_route_table.public.id
}
