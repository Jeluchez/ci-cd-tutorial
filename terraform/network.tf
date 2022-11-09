resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
}


# use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.private_subnet
  availability_zone = data.aws_availability_zones.available_zones.names[0]
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = var.public_subnet
  availability_zone = data.aws_availability_zones.available_zones.names[1]
}

# gateway for access to from internet
resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

# --------------------------- Asocciate route table with public route --------------------------- #

# create route table 
esource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.gw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(var.public_subnet)
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}
