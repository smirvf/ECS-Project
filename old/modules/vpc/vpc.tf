resource "aws_vpc" "WordPressVPC" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"

  tags = {
    Name = "WordPressVPC"
  }
}

resource "aws_internet_gateway" "IGW_WP" {
  vpc_id = aws_vpc.WordPressVPC.id
  tags = {
    Name = "IGW_WP"
  }
}

resource "aws_network_acl_association" "nacl_assoc_wp" {
  network_acl_id = aws_network_acl.NACl_WP.id
  subnet_id      = aws_subnet.SubnetWP.id
}

resource "aws_network_acl" "NACl_WP" {
  vpc_id = aws_vpc.WordPressVPC.id

  ingress {
    rule_no    = 85
    protocol   = "tcp"
    action     = "allow"
    cidr_block = var.ssh_ingress_cidr
    from_port  = 22
    to_port    = 22
  }

  ingress {
    rule_no    = 100
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  egress {
    rule_no    = 110
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 80
    to_port    = 80
  }

  ingress {
    rule_no    = 115
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  egress {
    rule_no    = 120
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 443
    to_port    = 443
  }

  ingress {
    rule_no    = 125
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  ingress {
    rule_no    = 130
    protocol   = "udp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    rule_no    = 135
    protocol   = "tcp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 1024
    to_port    = 65535
  }

  egress {
    rule_no    = 133
    protocol   = "udp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 53
    to_port    = 53
  }

  egress {
    rule_no    = 140
    protocol   = "udp"
    action     = "allow"
    cidr_block = "0.0.0.0/0" # or 169.254.169.123/32 (Amazon Time Sync)
    from_port  = 123
    to_port    = 123
  }

  ingress {
    rule_no    = 145
    protocol   = "icmp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    icmp_type  = -1 # any type
    icmp_code  = -1 # any code
    from_port  = 0
    to_port    = 0
  }

  egress {
    rule_no    = 150
    protocol   = "icmp"
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    icmp_type  = -1
    icmp_code  = -1
    from_port  = 0
    to_port    = 0
  }

  tags = {
    Name = "NACl_WP"
  }
}

resource "aws_subnet" "SubnetWP" {
  vpc_id                  = aws_vpc.WordPressVPC.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true

  tags = {
    Name = "SubnetWP"
  }
}

resource "aws_route_table" "RouteTableWP" {
  vpc_id = aws_vpc.WordPressVPC.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.IGW_WP.id
  }

  tags = {
    Name = "RouteTableWP"
  }
}

resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.SubnetWP.id
  route_table_id = aws_route_table.RouteTableWP.id
}