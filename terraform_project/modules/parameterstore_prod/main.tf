resource "aws_ssm_parameter" "project_name" {
  name  = "/global/prod/project_name"
  type  = "String"
  value = var.project_name
}

resource "aws_ssm_parameter" "hosted_zone_id" {
  name  = "/${var.project_name}/prod/hosted_zone_id"
  type  = "String"
  value = var.hosted_zone_id
}

resource "aws_ssm_parameter" "domain_name" {
  name  = "/${var.project_name}/prod/domain_name"
  type  = "String"
  value = var.domain_name
}

resource "aws_ssm_parameter" "site_full_domain_name" {
  name  = "/${var.project_name}/prod/site_full_domain_name"
  type  = "String"
  value = var.site_full_domain_name
}

resource "aws_ssm_parameter" "email_address" {
  name  = "/${var.project_name}/prod/email_address"
  type  = "String"
  value = var.email_address
}

resource "aws_ssm_parameter" "aws_region" {
  name  = "/${var.project_name}/prod/aws_region"
  type  = "String"
  value = var.aws_region
}

resource "aws_ssm_parameter" "repo_owner" {
  name  = "/${var.project_name}/prod/repo_owner"
  type  = "String"
  value = var.repo_owner
}

resource "aws_ssm_parameter" "app_repo_name" {
  name  = "/${var.project_name}/prod/app_repo_name"
  type  = "String"
  value = var.app_repo_name
}

resource "aws_ssm_parameter" "codeconnections_arn" {
  name  = "/${var.project_name}/prod/codeconnections_arn"
  type  = "String"
  value = var.codeconnections_arn
}

resource "aws_ssm_parameter" "repo_name" {
  name  = "/${var.project_name}/prod/repo_name"
  type  = "String"
  value = var.repo_name
}

resource "aws_ssm_parameter" "state_bucket_name" {
  name        = "/${var.project_name}/prod/state_bucket_name"
  description = "terraform state file bucket name"
  type        = "String"
  value       = var.state_bucket_name
}

resource "aws_ssm_parameter" "state_bucket_key" {
  name        = "/${var.project_name}/prod/state_bucket_key"
  description = "bootstrap state file location path"
  type        = "String"
  value       = var.state_bucket_key
}
