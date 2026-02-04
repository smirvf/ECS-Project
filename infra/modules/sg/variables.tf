variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "vpc_cidr_block" {
  type        = string
  description = "vpc cidr block used in vpc module"
}

variable "ecs_task_port" {
  type        = number
  description = "port for task"
}