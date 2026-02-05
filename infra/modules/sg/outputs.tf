output "alb_sg_id" {
  value       = aws_security_group.ecs_alb_sg.id
  description = "ALB SG id"
}

output "ecs_service_sg_id" {
  value       = aws_security_group.ecs_task_sg.id
  description = "ECS SG id"
}