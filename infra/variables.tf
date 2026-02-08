variable "ecs_task_port" {
  type        = number
  default     = 8080
  description = "port for task"
}

variable "alb_subnet_public" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "ALB SG id"
}

variable "aws_region" {
  type        = string
  default     = "eu-west-2"
  description = "Default aws region for proj"
}