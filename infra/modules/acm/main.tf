# ACM Section
data "aws_acm_certificate" "ecs_certificate" {
  domain      = var.ecs_domain
  statuses    = ["ISSUED"]
  most_recent = true
  types       = ["AMAZON_ISSUED"]
}

# Route 53 Hosted Zone Section
data "aws_route53_zone" "ecs_route53_zone" {
  name = var.ecs_route53_domain
}

# Route 53 Record Section
resource "aws_route53_record" "ecs_domain_record" {
  zone_id         = data.aws_route53_zone.ecs_route53_zone.zone_id
  name            = var.ecs_domain
  type            = "A"
  allow_overwrite = true

  alias {
    name                   = var.ecs_alb_dns_name
    zone_id                = var.ecs_alb_zone_id
    evaluate_target_health = true
  }
}
