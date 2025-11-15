resource "aws_kms_key" "ecr_key" {
  description             = "KMS key for ECR image encryption"
  deletion_window_in_days = 7    # 7 days grace period if we delete key
  enable_key_rotation     = true # auto-rotate key every year
}

resource "aws_kms_alias" "ecr_alias" {
  name          = "alias/threat-app-ecr-kms-key"
  target_key_id = aws_kms_key.ecr_key.key_id
}

resource "aws_ecr_repository" "threat_app_image" {
  name                 = "threat_app_image"
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
  encryption_configuration {
    encryption_type = "KMS"
    kms_key         = aws_kms_alias.ecr_alias.arn
  }
}

resource "aws_ecr_lifecycle_policy" "threat_image_policy" {
  repository = aws_ecr_repository.threat_app_image.name
  policy     = <<EOF
{
    "rules": [
        {
            "rulePriority": 1,
            "description": "Keep the 5 latest images",
            "selection": {
                "tagStatus": "any",
                "countType": "imageCountMoreThan",
                "countNumber": 5
            },
            "action": {
                "type": "expire"
            }
        }
    ]
}
EOF
}
