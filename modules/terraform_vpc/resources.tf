# Main VPC
resource "aws_vpc" "manaya-tf2" {
  cidr_block = var.cidr_block
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "manaya-tf2-vpc"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "manaya-tf-igw" {
  vpc_id = aws_vpc.manaya-tf2.id

  tags = {
    Name = "manaya tf2 IGW"
  }
}

# Create Subnets
resource "aws_subnet" "pubsubs" {
  count = 3

  cidr_block = cidrsubnet(var.cidr_block, 4, count.index)
  vpc_id = aws_vpc.manaya-tf2.id
  map_public_ip_on_launch = true

  tags = {
    Name = "manaya-pubsub-tf2-${count.index + 1}"
  }
}

resource "aws_subnet" "privsubs" {
  count = 3

  cidr_block = cidrsubnet(var.cidr_block, 4, count.index)
  vpc_id = aws_vpc.manaya-tf2.id
  map_public_ip_on_launch = true

  tags = {
    Name = "manaya-privsub-tf2-${count.index + 1}"
  }
}

# Create NAT Gateway
resource "aws_nat_gateway" "manaya-tf-natgw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id = aws_subnet.public-subnet[0].id
  depends_on = [aws_internet_gateway.igw]

  tags = {
    Name = "manaya tf2 NATGW"
  }
}

# Create Elastic IP
resource "aws_eip" "nat-eip" {
  vpc = true
}

# Create Public Route Table
resource "aws_route_table" "manaya-tf-PubRT" {
  vpc_id = aws_vpc.manaya-tf2.id

  route {
    cidr_block = "${var.all_ips}"
    nat_gateway_id = aws_internet_gateway.manaya-tf-igw.id
  }

  tags =  {
    Name = "manaya tf2 PubRT"
  }
}

# Create Private Route Table
resource "aws_route_table" "manaya-tf-PrivRT" {
  vpc_id = aws_vpc.manaya-tf2.id

  route {
    cidr_block = "${var.all_ips}"
    nat_gateway_id = aws_nat_gateway.manaya-tf-natgw.id
  }

  tags =  {
    Name = "manaya tf2 PrivRT"
  }
}

# Associate Route Tables
resource "aws_route_table_association" "puba" {
  count = 3
  subnet_id      = aws_subnet.pubsubs[count.index].id
  route_table_id = aws_route_table.manaya-tf-PubRT.id
}

resource "aws_route_table_association" "priva" {
  count = 3
  subnet_id      = aws_subnet.privsubs[count.index].id
  route_table_id = aws_route_table.manaya-tf-PrivRT.id
}

# Create Security Groups
resource "aws_security_group" "sg_22" {
  name = "manaya-tf-sg"
  vpc_id = "${aws_vpc.manaya-tf2.id}"

  # SSH access from the VPC
  ingress {
      from_port   = 22
      to_port     = 22
      protocol    = "tcp"
      cidr_blocks = ["${var.all_ips}"]
  }

  ingress {
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks = ["${var.all_ips}"]
  }

  ingress {
      from_port   = 443
      to_port     = 443
      protocol    = "tcp"
      cidr_blocks = ["${var.all_ips}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${var.all_ips}"]
  }
}
