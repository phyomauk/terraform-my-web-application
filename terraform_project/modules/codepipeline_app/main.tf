# -----------------------------------------------
# CodePipeline for Containerized App Deployment to ECS
# -----------------------------------------------
resource "aws_codepipeline" "this" {
  name     = "${var.project_name}-app-pipeline"
  role_arn = var.codepipeline_role_arn

  artifact_store {
    type     = "S3"
    location = var.artifacts_bucket_name
  }

  # terraform infra codes  
  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = var.codeconnections_arn
        FullRepositoryId = "${var.repo_owner}/${var.app_repo_name}"
        BranchName       = var.branch
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      version          = "1"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]

      configuration = {
        ProjectName = var.codebuild_project_name
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name     = "CodeDeploy"
      category = "Deploy"
      owner    = "AWS"
      provider = "CodeDeployToECS"
      version  = "1"

      input_artifacts = [
        "build_output"
      ]

      configuration = {
        ApplicationName     = var.codedeploy_application_name
        DeploymentGroupName = var.deployment_group_name

        TaskDefinitionTemplateArtifact = "build_output"
        TaskDefinitionTemplatePath     = "taskdef.json"

        AppSpecTemplateArtifact = "build_output"
        AppSpecTemplatePath     = "appspec.yaml"
      }
    }
  }

}