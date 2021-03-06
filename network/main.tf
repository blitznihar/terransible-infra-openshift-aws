#Create VPC
resource "aws_vpc" "vpc_devops" {
  cidr_block           = "${var.cidr_block}"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "DevOps"
  }
}

#Create Subnets
resource "aws_subnet" "subnet_01_devops" {
  cidr_block              = "${var.cidr_subnet1_block}"
  vpc_id                  = "${aws_vpc.vpc_devops.id}"
  availability_zone       = "${var.cidr_subnet1_availability_zone}"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnetA"
  }
}

resource "aws_subnet" "subnet_02_devops" {
  cidr_block              = "${var.cidr_subnet2_block}"
  vpc_id                  = "${aws_vpc.vpc_devops.id}"
  availability_zone       = "${var.cidr_subnet2_availability_zone}"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnetB"
  }
}

resource "aws_subnet" "subnet_03_devops" {
  cidr_block              = "${var.cidr_subnet3_block}"
  vpc_id                  = "${aws_vpc.vpc_devops.id}"
  availability_zone       = "${var.cidr_subnet3_availability_zone}"
  map_public_ip_on_launch = true

  tags = {
    Name = "subnetC"
  }
}

#Create IGW - Internet Gateway
resource "aws_internet_gateway" "internet_gateway_devops" {
  vpc_id = "${aws_vpc.vpc_devops.id}"

  tags = {
    Name = "igw_devops"
  }
}

#Create Route Tables
resource "aws_route_table" "route_table_devops" {
  vpc_id = "${aws_vpc.vpc_devops.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.internet_gateway_devops.id}"
  }

  tags = {
    Name = "igw_devops"
  }
}

resource "aws_route_table_association" "aws_route_table_association_subnet01_devops" {
  subnet_id      = "${aws_subnet.subnet_01_devops.id}"
  route_table_id = "${aws_route_table.route_table_devops.id}"
}

# Network Security

resource "aws_security_group" "aws_security_group_devops" {
  name        = "aws_security_group_devops"
  description = "Used for access to the public instances"
  vpc_id      = "${aws_vpc.vpc_devops.id}"

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }

  #HTTP

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 53
    to_port     = 53
    protocol    = "udp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 8000
    to_port     = 9400
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 10250
    to_port     = 10255
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block}"]
  }
  ingress {
    from_port   = 2379
    to_port     = 2380
    protocol    = "tcp"
    cidr_blocks = ["${var.cidr_block}"]
  }
  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 4789
    to_port     = 4790
    protocol    = "udp"
    cidr_blocks = ["${var.access_ip}"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 10010
    to_port     = 10249
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
  ingress {
    from_port   = 6781
    to_port     = 6785
    protocol    = "tcp"
    cidr_blocks = ["${var.access_ip}"]
  }
}
