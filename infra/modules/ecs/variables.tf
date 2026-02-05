variable "ecs_ecr_repo_name" {
  type        = string
  default     = "smirvf_ecs-project"
  description = "ECR repo name!"
}
variable "ecs_alb_target_group_arn" {
  type        = string
  description = "ECS ALB Target Group ARN"
}

# variable "ecs_alb_listener_443" {
#   type        = string
# }
variable "ecs_service_sg_id" {
  type = string
}

variable "ecs_subnet_private_2a_id" {
  type = string
}
variable "ecs_subnet_private_2b_id" {
  type = string
}
