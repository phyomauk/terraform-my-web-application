# ----------------------------
# CodeBuild: Deploy Application codes
# ----------------------------
resource "aws_codebuild_project" "build" {
  name         = "${var.project_name}-build-app"
  description  = "Builds Docker images for frontend and backend containers"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "aws/app.yml" # referncing to GitHub app repo
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    privileged_mode             = true
    image_pull_credentials_type = "CODEBUILD"

    environment_variable {
      name  = "AWS_ACCOUNT_ID"
      value = data.aws_caller_identity.current.account_id
    }

    environment_variable {
      name  = "ECR_HOSTNAME"
      value = var.ecr_hostname
    }

    environment_variable {
      name  = "FRONTEND_ECR_REPO_NAME"
      value = var.frontend_ecr_repo_name
    }

    environment_variable {
      name  = "FRONTEND_ECR_REPO_URL"
      value = var.frontend_ecr_repo_url
    }

    environment_variable {
      name  = "BACKEND_ECR_REPO_NAME"
      value = var.backend_ecr_repo_name
    }

    environment_variable {
      name  = "BACKEND_ECR_REPO_URL"
      value = var.backend_ecr_repo_url
    }

    environment_variable {
      name  = "TAG"
      value = var.image_tag
    }

    environment_variable {
      name  = "FRONTEND_CONTAINER_NAME"
      value = var.frontend_container_name
    }

    environment_variable {
      name  = "BACKEND_CONTAINER_NAME"
      value = var.backend_container_name
    }

    environment_variable {
      name  = "TASK_FAMILY_NAME"
      value = var.project_name
    }

    environment_variable {
      name  = "ECS_TASK_EXECUTION_ROLE_ARN"
      value = var.ecs_task_execution_role_arn
    }

    environment_variable {
      name  = "DOCDB_URI_ARN"
      value = var.docdb_uri_arn
      # value = "/${var.project_name}/docdb/uri"
    }

    environment_variable {
      name  = "LOG_GROUP_NAME"
      value = var.log_group_name
      # value = "/ecs/${var.project_name}"
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "/aws/${var.project_name}/codebuild/app"
      stream_name = "build-log"
    }
  }

  tags = {
    Name = "${var.project_name}-codebuild"
  }
}