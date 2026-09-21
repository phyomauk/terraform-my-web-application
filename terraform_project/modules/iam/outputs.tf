output "codepipeline_role_arn" {
  value = aws_iam_role.codepipeline_role.arn
}

output "codebuild_role_arn" {
  value = aws_iam_role.codebuild_role.arn
}

output "ecs_task_exec_role_arn" {
  value = aws_iam_role.ecs_task_execution_role.arn
}

output "tf_admin_role_arn" {
  value = aws_iam_role.tf_admin.arn
}

output "codedeploy_role_arn" {
  value = aws_iam_role.codedeploy_role.arn
}