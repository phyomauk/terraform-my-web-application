output "backend_ecr_url" {
  value = module.ecr.backend_ecr_repo_url
}

output "frontend_ecr_url" {
  value = module.ecr.frontend_ecr_repo_url
}

output "artifacts_bucket_arn" {
  value = module.s3_artifacts.artifacts_bucket_arn
}

output "ecs_task_execution_role_arn" {
  value = module.iam_roles.ecs_task_exec_role_arn
}

output "codepipeline_role_arn" {
  value = module.iam_roles.codepipeline_role_arn
}

output "codebuild_role_arn" {
  value = module.iam_roles.codebuild_role_arn
}

output "codedeploy_role_arn" {
  value = module.iam_roles.codedeploy_role_arn
}

output "ecr_hostname" {
  value = module.ecr.ecr_hostname
}

output "frontend_ecr_repo_url" {
  value = module.ecr.frontend_ecr_repo_url
}

output "frontend_ecr_repo_name" {
  value = module.ecr.frontend_ecr_repo_name
}

output "backend_ecr_repo_url" {
  value = module.ecr.backend_ecr_repo_url
}

output "backend_ecr_repo_name" {
  value = module.ecr.backend_ecr_repo_name
}

output "artifacts_bucket_name" {
  value = module.s3_artifacts.artifacts_bucket_name
}