variable "project_name" {
  type        = string
  description = "Project name tag for resources"
}

variable "codedeploy_role_arn" {
  type        = string
  description = "IAM Role ARN for AWS CodeDeploy"
}

variable "ecs_cluster_name" {
  type        = string
  description = "Name of the target ECS Cluster"
}

variable "ecs_service_name" {
  type        = string
  description = "Name of the target ECS Service"
}

variable "alb_listener_prod_arn" {
  type        = string
  description = "ARN of the production ALB listener (e.g., Port 80/443)"
}

variable "alb_listener_test_arn" {
  type        = string
  description = "ARN of the test ALB listener (e.g., Port 8080/8443)"
}

variable "target_group_blue_name" {
  type        = string
  description = "Name of the Blue Target Group"
}

variable "target_group_green_name" {
  type        = string
  description = "Name of the Green Target Group"
}

variable "deployment_config_name" {
  type        = string
  default     = "CodeDeployDefault.ECSAllAtOnce" # Options: ECSLinear10PercentEvery1Minute, ECSCanary10Percent5Minutes, etc.
  description = "CodeDeploy routing configuration"
}

variable "termination_wait_time" {
  type        = number
  default     = 2
  description = "Minutes to wait before terminating the old (Blue) ECS task set after successful cutover"
}