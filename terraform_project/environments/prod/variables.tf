variable "project_name" {
  default = "phyo-web-application"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
}

variable "domain_name" {
  description = "fully qualified domain name"
}

variable "email_address" {
  description = "email address to receive messages from SNS"
}

variable "site_full_domain_name" {
}

variable "aws_region" {
}

variable "repo_owner" {
  description = "repository owner name"
}

variable "repo_name" {
  description = "infrastructure code repository name"
}

variable "codeconnections_arn" {
  description = "AWS codeconnections_arn for GitHub"
}

variable "app_repo_name" {
  description = "application code repository name"
}

variable "state_bucket_name" {
  description = "bootstrap state bucket name"
}

variable "state_bucket_key" {
  description = "boostrap state file location"
}