output "alb_arn" {
  value = aws_lb.ecs_alb.arn
}

output "ecs_alb_dns_name" {
  value       = aws_lb.ecs_alb.dns_name
  description = "ALB DNS"
}

output "ecs_alb_zone_id" {
  value       = aws_lb.ecs_alb.zone_id
  description = "ALB Zone ID for Route53 alias"
}

output "target_group_arn" {
  value = aws_lb_target_group.ecs_target_group.arn
}

output "https_listener_arn" {
  value = aws_lb_listener.ecs_alb_listener.arn
}
output "ecs_alb_dimension" {
  value = aws_lb.ecs_alb.arn_suffix
}

