# Frontend
output "frontend_ecr_repo_arn" {
  value = aws_ecr_repository.frontend_repo.arn
}

output "frontend_ecr_repo_url" {
  value = aws_ecr_repository.frontend_repo.repository_url
}

output "frontend_ecr_repo_name" {
  description = "The name of the frontend registry"
  value       = aws_ecr_repository.frontend_repo.name
}


# Backend
output "backend_ecr_repo_arn" {
  value = aws_ecr_repository.backend_repo.arn
}

output "backend_ecr_repo_url" {
  value = aws_ecr_repository.backend_repo.repository_url
}

output "backend_ecr_repo_name" {
  value = aws_ecr_repository.backend_repo.name
}

# ECR Hostname 
output "ecr_hostname" {
  value       = split("/", aws_ecr_repository.frontend_repo.repository_url)[0]
  description = "The ECR Registry Hostname used for docker login"
}