# Security Group Section
resource "aws_security_group" "ecs_alb_sg" {
  name        = "ecs_alb_sg"
  description = "ECS ALB SG- Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "ecs_alb_sg"
    Project = "ecs"
  }
}

resource "aws_security_group" "ecs_task_sg" {
  name        = "ecs_task_sg"
  description = "ECS Task SG"
  vpc_id      = var.vpc_id

  tags = {
    Name    = "ecs_task_sg"
    Project = "ecs"
  }
}

# Security Group Rules Section

resource "aws_vpc_security_group_ingress_rule" "alb_443_ipv4" {
  security_group_id = aws_security_group.ecs_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}
resource "aws_vpc_security_group_ingress_rule" "alb_80_ipv4" {
  security_group_id = aws_security_group.ecs_alb_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_egress_rule" "alb_to_tasks" {
  security_group_id            = aws_security_group.ecs_alb_sg.id
  referenced_security_group_id = aws_security_group.ecs_task_sg.id
  from_port                    = var.ecs_task_port
  to_port                      = var.ecs_task_port
  ip_protocol                  = "tcp"
}

resource "aws_vpc_security_group_ingress_rule" "ingress_ecs_task" {
  security_group_id            = aws_security_group.ecs_task_sg.id
  referenced_security_group_id = aws_security_group.ecs_alb_sg.id

  from_port   = var.ecs_task_port
  ip_protocol = "tcp"
  to_port     = var.ecs_task_port
}

resource "aws_vpc_security_group_egress_rule" "egress_ecs_task" {
  security_group_id = aws_security_group.ecs_task_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}

