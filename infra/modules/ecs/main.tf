# CloudWatch Group Section
resource "aws_cloudwatch_log_group" "ecs_cw_group" {
  name              = "/ecs/threat-app"
  retention_in_days = 3
  #   setting retention to 3 days as more isn't required

  tags = {
    Name    = "ecs_cloudWatch_group"
    Project = "ecs"
  }
}

# ECS Cluster Section
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

# IAM Role Section
data "aws_iam_role" "ecs_task_execution_iam_role" {
  name = "ecsTaskExecutionRole"
}

data "aws_ecr_image" "ecr_image_name" {
  repository_name = var.ecs_ecr_repo_name
  most_recent     = true
}

# Task Definition Section
resource "aws_ecs_task_definition" "ecs_task_definition" {
  family                   = "ecs_task_definition"
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = 512
  memory                   = 1024
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_iam_role.arn

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "threat-app"
      image     = data.aws_ecr_image.ecr_image_name.image_uri
      essential = true
      cpu       = 512
      memory    = 1024

      portMappings = [
        {
          containerPort = 8080
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = aws_cloudwatch_log_group.ecs_cw_group.name
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "threat-app-task"
        }
      }
    }
  ])
}

# ECS Service Section
resource "aws_ecs_service" "ecs_proj_service" {
  name            = "ecs_proj_service"
  launch_type     = "FARGATE"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_definition.arn
  desired_count   = 2

  network_configuration {
    security_groups  = [var.ecs_service_sg_id]
    subnets          = [var.ecs_subnet_private_2a_id, var.ecs_subnet_private_2b_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.ecs_alb_target_group_arn
    container_name   = "threat-app"
    container_port   = 8080
  }

  tags = {
    Name    = "ecs_service"
    Project = "ecs"
  }
}
