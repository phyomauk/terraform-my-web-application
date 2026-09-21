output "ecs_cluster_name" {
  value = aws_ecs_cluster.cluster.name
}

output "ecs_service_name" {
  value = aws_ecs_service.service.name
}

# Outputs a list of all container names: ["frontend", "backend"]
output "container_names" {
  value = [for c in jsondecode(aws_ecs_task_definition.task.container_definitions) : c.name]
}

# Outputs a map of index to name: { "frontend" = "frontend", "backend" = "backend" }
output "container_name_map" {
  value = {
    for c in jsondecode(aws_ecs_task_definition.task.container_definitions) : c.name => c.name
  }
}