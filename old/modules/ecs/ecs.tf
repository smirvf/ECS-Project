resource "aws_instance" "WordPressEC2" {
  ami                         = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = aws_subnet.SubnetWP.id
  vpc_security_group_ids      = [aws_security_group.ec2sg.id]
  associate_public_ip_address = true
  key_name                    = aws_key_pair.wp_key.key_name
  user_data                   = file("${path.module}/userdataChallenge2.sh")

  tags = {
    Name = "WordPressEC2"
  }
}

resource "aws_key_pair" "wp_key" {
  key_name   = var.ssh_key_name
  public_key = file(var.ssh_public_key_path)
  tags       = { Name = var.ssh_key_name }
}

resource "aws_security_group" "ec2sg" {
  vpc_id = aws_vpc.WordPressVPC.id
  tags = {
    Name = "ec2sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ec2sg22" {
  security_group_id = aws_security_group.ec2sg.id
  cidr_ipv4         = var.ssh_ingress_cidr
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

resource "aws_vpc_security_group_ingress_rule" "ec2sg443" {
  security_group_id = aws_security_group.ec2sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "ec2sg80" {
  security_group_id = aws_security_group.ec2sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "ec2sg_icmp" {
  security_group_id = aws_security_group.ec2sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "icmp"
  from_port         = -1
  to_port           = -1
  description       = "Allow ping (ICMP)"
}

resource "aws_vpc_security_group_egress_rule" "ec2_all_out" {
  security_group_id = aws_security_group.ec2sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
}
