### VPC ###

resource "aws_vpc" "test-env" {
  cidr_block = "10.0.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support = true

  tags =  {
    Name = "${var.project_name}-vpc"
  }
}

### Subnets ###

resource "aws_subnet" "jenkins-subnet" {
  cidr_block = "10.0.1.0/24"
  vpc_id = aws_vpc.test-env.id
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"

  tags =  {
    Name = "${var.project_name}-jenkins-subnet"
  }
}

resource "aws_subnet" "app-subnet" {
  cidr_block = "10.0.2.0/24"
  vpc_id = aws_vpc.test-env.id
  map_public_ip_on_launch = "true"
  availability_zone = "eu-west-1a"

  tags =  {
    Name = "${var.project_name}-app-subnet"
  }
}

### Internet Gateway ###

resource "aws_internet_gateway" "test-env-gw" {
  vpc_id = aws_vpc.test-env.id
}

### Route Table ###

resource "aws_route_table" "route-table-test-env" {
  vpc_id = aws_vpc.test-env.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test-env-gw.id
  }
}

### Route Table Associations ###

resource "aws_route_table_association" "jenkins-subnet-association" {
  subnet_id      = aws_subnet.jenkins-subnet.id
  route_table_id = aws_route_table.route-table-test-env.id
}

resource "aws_route_table_association" "app-subnet-association" {
  subnet_id      = aws_subnet.app-subnet.id
  route_table_id = aws_route_table.route-table-test-env.id
}