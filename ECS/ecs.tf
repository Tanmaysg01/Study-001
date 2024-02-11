resource "aws_ecs_cluster" "ecs" {
  name = "cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

#taskdefination
resource "aws_ecs_task_definition" "task" {
  family = "service"
  container_definitions = jsonencode([
    {
      name      = "first"
      image     = "service-first"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    },
    {
      name      = "second"
      image     = "service-second"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 443
          hostPort      = 443
        }
      ]
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [us-west-2a, us-west-2b]"
  }
}

#ecs service
resource "aws_ecs_service" "service" {
  name            = "mongodb"
  cluster         = aws_ecs_cluster.ecs.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 3
  iam_role        = "arn:aws:iam::446611234961:role/aws-service-role/ecs.amazonaws.com/AWSServiceRoleForECS"
  

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }
}