resource "aws_ecs_cluster" "cluster" {
  name               = var.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    capacity_provider = "FARGATE"
    weight            = "100"
  }
}


resource "aws_ecs_task_definition" "task" {
  family = "service"
  requires_compatibilities = [
    "FARGATE",
  ]
  execution_role_arn = var.role
  network_mode       = "awsvpc"
  cpu                = 1024
  memory             = 2048
  container_definitions = jsonencode([
    {
      name      = "hello-world"   # "application"
      image     = "docker.io/pvermeyden/nodejs-hello-world:a1e8cf1edcc04e6d905078aed9861807f6da0da4"  # "particule/helloworld"
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
}

resource "aws_ecs_service" "service" {
  name            = "pearlDemo"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1

  network_configuration {
    subnets          = var.subnet
    assign_public_ip = true
    security_groups = var.ecsSG
  }

  load_balancer {
    target_group_arn = var.tg  # our target group
    container_name   = "hello-world"      # "application"
    container_port   = 80
  }
  capacity_provider_strategy {
    base              = 0
    capacity_provider = "FARGATE"
    weight            = 100
  }
}