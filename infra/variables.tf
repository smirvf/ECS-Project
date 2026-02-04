variable "ecs_task_port" {
  type        = number
  description = "port for task"
}

variable "alb_subnet_public" {
  type        = list(string)
  description = "ALB SG id"
}