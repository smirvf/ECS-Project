output "ecs_domain" {
  value = data.aws_acm_certificate.ecs_certificate.domain
}