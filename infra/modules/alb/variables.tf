variable "alb_sg_id" {
  type        = string
  description = "ALB SG id"
}

variable "alb_subnet_public" {
  type        = list(string)
  description = "ALB SG id"
}

variable "vpc_id" {
  type        = string
  description = "vpc id"
}

variable "ecs_task_port" {
  type        = number
  description = "port for task"
}

variable "acm_cert_arn" {
  type        = string
  description = "ACM Cert ARN"
}

variable "alb_ssl_policy" {
  type    = string
  default = "ELBSecurityPolicy-TLS13-1-2-2021-06"
}

variable "ecs_domain" {
  type    = string
  default = "ecs.saahirmir.com"
}