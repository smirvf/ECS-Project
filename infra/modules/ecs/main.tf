# ECS Cluster Section
resource "aws_ecs_cluster" "ecs_cluster" {
  name = "ecs_cluster"
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
  execution_role_arn       = data.aws_iam_role.ecs_task_execution_iam_role.arn

  cpu    = 512
  memory = 1024

  runtime_platform {
    operating_system_family = "LINUX"
  }

  container_definitions = jsonencode([
    {
      name      = "threat-app"
      image     = data.aws_ecr_image.ecr_image_name.image_uri
      essential = true
      portMappings = [
        {
          containerPort = 8080
        }
      ]
    }
  ])
}

# ECS Service Section
resource "aws_ecs_service" "ecs_" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.foo.id
  task_definition = aws_ecs_task_definition.mongo.arn
  desired_count   = 3
  iam_role        = aws_iam_role.foo.arn
  depends_on      = [aws_iam_role_policy.foo]

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.foo.arn
    container_name   = "mongo"
    container_port   = 8080
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}
