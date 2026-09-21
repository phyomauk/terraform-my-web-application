variable "project_name" {
  type = string
}

variable "ecs_cluster_name" {
  type = string
}

variable "ecs_service_name" {
  type = string
}

variable "alb_arn_suffix" {
  type = string
}

variable "sns_topic_arn" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "green_target_group_arn_suffix" {

}