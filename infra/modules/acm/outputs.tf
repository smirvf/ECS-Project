output "ecs_domain" {
  value = data.aws_acm_certificate.ecs_certificate.domain
}

output "ecs_acm_cert_arn" {
  value = data.aws_acm_certificate.ecs_certificate.arn
}

