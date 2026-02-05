# Target Group Section
resource "aws_lb_target_group" "ecs_target_group" {
  name        = "ecs-target-group"
  port        = var.ecs_task_port
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/health"
    protocol            = "HTTP"
    matcher             = "200"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  tags = {
    Name    = "ecs-target-group"
    Project = "ecs"
  }
}

# ALB Section
resource "aws_lb" "ecs_alb" {
  name               = "ecs-alb"
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.alb_subnet_public
  # enable_deletion_protection = true - if i wanted for prod but i need to del so it doesn't drain my wallet

  tags = {
    Name    = "ecs-alb"
    Project = "ecs"
  }
}

# Listeners Section
resource "aws_lb_listener" "ecs_alb_listener" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = var.alb_ssl_policy
  certificate_arn   = data.aws_acm_certificate.ecs_certificate.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ecs_target_group.arn
  }

  tags = {
    Name    = "ecs-alb-listener-443"
    Project = "ecs"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ecs_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
  tags = {
    Name    = "ecs-alb-listener-80"
    Project = "ecs"
  }
}


# ACM Certificate Section
data "aws_acm_certificate" "ecs_certificate" {
  domain      = var.ecs_domain
  statuses    = ["ISSUED"]
  most_recent = true
  types       = ["AMAZON_ISSUED"]
}
