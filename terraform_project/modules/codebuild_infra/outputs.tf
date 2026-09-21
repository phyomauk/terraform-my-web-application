output "codebuild_infra_arn" {
  value = aws_codebuild_project.tf_execution.arn
}

output "build_project_name" {
  value = aws_codebuild_project.tf_execution.name
}

