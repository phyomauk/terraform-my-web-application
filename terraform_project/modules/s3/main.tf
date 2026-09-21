resource "random_id" "s3_suffix" {
  byte_length = 4
}

# s3 bucket to store codepipeline artifacts
resource "aws_s3_bucket" "artifacts" {
  bucket        = "${var.project_name}-codepipeline-artifacts-${random_id.s3_suffix.hex}"
  force_destroy = true
  tags = {
    Name = "${var.project_name}"
  }
}

