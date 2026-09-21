# Codebuild: deploy infra 
resource "aws_codebuild_project" "tf_execution" {
  name         = "${var.project_name}-codebuild-infra"
  service_role = var.codebuild_role_arn

  artifacts {
    type = "CODEPIPELINE"
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terraform_project/buildspecs/infra/infra.yml"
    # buildspec = file("${path.module}/../../buildspecs/infra/infra.yml")
  }

  environment {
    compute_type = "BUILD_GENERAL1_SMALL"
    image        = "aws/codebuild/standard:7.0"
    type         = "LINUX_CONTAINER"

    environment_variable {
      name  = "TF_ADMIN_ROLE_ARN"
      value = var.tf_admin_role_arn
    }

    environment_variable {
      name  = "PROJECT_NAME"
      value = var.project_name
    }
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild_infra.name
      stream_name = "build-log"
    }
  }

}

resource "aws_cloudwatch_log_group" "codebuild_infra" {
  name              = "/aws/${var.project_name}/codebuild/infra"
  retention_in_days = 30
}