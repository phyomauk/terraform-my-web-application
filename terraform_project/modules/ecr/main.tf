resource "aws_ecr_repository" "frontend_repo" {
  name                 = "frontend/${var.project_name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

}

resource "aws_ecr_repository" "backend_repo" {
  name                 = "backend/${var.project_name}"
  image_tag_mutability = "MUTABLE"
  force_delete         = true

}