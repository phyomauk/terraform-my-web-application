
##################################################
# codepipeline role and permission
##################################################
resource "aws_iam_role" "codepipeline_role" {
  name = "${var.project_name}-pipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codepipeline.amazonaws.com"
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_policy" "codepipeline_policy" {
  name = "${var.project_name}-pipeline-policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [

      ############################################
      # Github connection
      ############################################
      {
        Effect = "Allow"
        Action = [
          "codeconnections:UseConnection",
          "codestar-connections:UseConnection"
        ]
        Resource = [
          "arn:aws:codestar-connections:*:${data.aws_caller_identity.current.account_id}:connection/${var.codeconnections_id}",
          "arn:aws:codeconnections:*:${data.aws_caller_identity.current.account_id}:connection/${var.codeconnections_id}"
        ]
      },

      ############################################
      # S3 (pipeline artifacts)
      ############################################
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:GetObjectVersion",
          "s3:PutObject",
          "s3:GetBucketVersioning"
        ]
        Resource = [
          "${var.artifacts_bucket_arn}",
          "${var.artifacts_bucket_arn}/*"
        ]
      },

      ############################################
      # CodeBuild
      ############################################
      {
        Effect = "Allow"
        Action = [
          "codebuild:BatchGetBuilds",
          "codebuild:StartBuild",
          "codebuild:BatchGetBuildBatches",
          "codebuild:StartBuildBatch"
        ]
        Resource = "*"
      },

      ############################################
      # ECS Deploy
      ############################################
      {
        Effect = "Allow"
        Action = [
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:RegisterTaskDefinition",
          "ecs:UpdateService"
        ]
        Resource = "*"
      },

      ############################################
      # Codedeploy
      ############################################      
      {
        Effect = "Allow"
        Action = [
          "codedeploy:GetApplication",
          "codedeploy:GetApplicationRevision",
          "codedeploy:GetDeployment",
          "codedeploy:GetDeploymentConfig",
          "codedeploy:GetDeploymentGroup",
          "codedeploy:CreateDeployment",
          "codedeploy:RegisterApplicationRevision"
        ]
        Resource = "*"
      },

      ############################################
      # IAM PassRole (critical for ECS deploy)
      ############################################
      {
        Effect = "Allow"
        Action = [
          "iam:PassRole"
        ]
        Resource = [
          aws_iam_role.ecs_task_execution_role.arn
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "codepipeline_attach" {
  role       = aws_iam_role.codepipeline_role.name
  policy_arn = aws_iam_policy.codepipeline_policy.arn
}