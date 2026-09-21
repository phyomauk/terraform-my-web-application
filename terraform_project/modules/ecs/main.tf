data "aws_region" "current" {

}

# ecs cluster
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project_name}-cluster"
}

resource "aws_ecs_task_definition" "task" {
  family                   = var.project_name
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"

  cpu    = 512
  memory = 1024

  execution_role_arn = var.ecs_task_execution_role_arn

  container_definitions = jsonencode([

    {
      name      = "frontend"
      image     = "${var.frontend_repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "frontend"
        }
      }
    },

    {
      name      = "backend"
      image     = "${var.backend_repository_url}:${var.image_tag}"
      essential = true

      portMappings = [
        {
          containerPort = 5000
          hostPort      = 5000
        }
      ]

      # fetch the parameter form SSM and injects it as process.env.MONGO_URI
      secrets = [
        {
          name      = "MONGO_URI"
          valueFrom = var.docdb_uri_arn
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = var.log_group_name
          awslogs-region        = data.aws_region.current.name
          awslogs-stream-prefix = "backend"
        }
      }
    }

  ])
}

# ecs service
resource "aws_ecs_service" "service" {
  name            = var.project_name
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  deployment_controller {
    type = "CODE_DEPLOY"
  }
  # deployment_minimum_healthy_percent = 100
  # deployment_maximum_percent         = 200

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_sg_id]

    assign_public_ip = false
  }

  # Initialize pointing to the BLUE target group
  load_balancer {
    target_group_arn = var.blue_target_group_arn
    container_name   = "frontend"
    container_port   = 80
  }

  # Prevent Terraform Drift:
  # Ingnore external changes to load_blancer and task_definition made by CodeDeploy
  lifecycle {
    ignore_changes = [
      load_balancer,
      task_definition
    ]
  }

  depends_on = [
    aws_ecs_cluster.cluster
  ]
}

