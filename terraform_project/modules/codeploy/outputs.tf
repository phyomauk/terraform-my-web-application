output "application_name" {
  value = aws_codedeploy_app.ecs_app.name
}

output "deployment_group_name" {
  value = aws_codedeploy_deployment_group.ecs_group.deployment_group_name
}

output "application_id" {
  value = aws_codedeploy_app.ecs_app.id
}

output "deployment_group_arn" {
  value = aws_codedeploy_deployment_group.ecs_group.arn
}