# ------------------------------------------------------------------------------
# CodeDeploy Application
# ------------------------------------------------------------------------------
resource "aws_codedeploy_app" "ecs_app" {
  compute_platform = "ECS"
  name             = "${var.project_name}-app"
}

# ------------------------------------------------------------------------------
# CodeDeploy Deployment Group
# ------------------------------------------------------------------------------
resource "aws_codedeploy_deployment_group" "ecs_group" {
  app_name               = aws_codedeploy_app.ecs_app.name
  deployment_group_name  = "${var.project_name}-dg"
  service_role_arn       = var.codedeploy_role_arn
  deployment_config_name = var.deployment_config_name # e.g., CodeDeployDefault.ECSAllAtOnce

  # Required block for ECS Blue/Green deployments
  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  # 1. Traffic Shifting & Blue/Green Configuration
  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "CONTINUE_DEPLOYMENT"
      wait_time_in_minutes = 0
    }

    terminate_blue_instances_on_deployment_success {
      action                           = "TERMINATE"
      termination_wait_time_in_minutes = var.termination_wait_time # e.g., 5
    }
  }

  # 2. Target ECS Service & Cluster
  ecs_service {
    cluster_name = var.ecs_cluster_name
    service_name = var.ecs_service_name
  }

  # 3. ALB Target Group Pair & Listener Routes
  load_balancer_info {
    target_group_pair_info {
      prod_traffic_route {
        listener_arns = [var.alb_listener_prod_arn]
      }

      test_traffic_route {
        listener_arns = [var.alb_listener_test_arn]
      }

      target_group {
        name = var.target_group_blue_name
      }

      target_group {
        name = var.target_group_green_name
      }
    }
  }

  # 4. Rollback Configuration on Failure
  auto_rollback_configuration {
    enabled = true
    events  = ["DEPLOYMENT_FAILURE"]
  }
}