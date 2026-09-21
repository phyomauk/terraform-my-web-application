variable "project_name" {
  default = "phyo-web-application"
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID"
}

variable "domain_name" {
  description = "fully qualified domain name"
  default     = "phyomauk.click"
}

variable "email_address" {
  description = "email address to receive messages from SNS"
}

variable "site_full_domain_name" {
  description = "the web application site domain name"
  default     = "*.phyomauk.click"
}

variable "aws_region" {
  description = "aws region"
  default     = "us-west-2"
}

variable "repo_owner" {
  description = "repository owner name"
  default     = "phyomauk"
}

variable "app_repo_name" {
  description = "application code repository name"
  default     = "app-my-web-application"
}

variable "codeconnections_arn" {
  description = "AWS codeconnections_arn for GitHub"
}

variable "repo_name" {
  description = "terraform code repo name"
}

variable "state_bucket_name" {
  description = "terraform state file bucket name"
}

variable "state_bucket_key" {
  description = "bootstrap state file path"
}
