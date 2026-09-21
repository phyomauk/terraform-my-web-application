
resource "aws_iam_role" "tf_admin" {
  name = "${var.project_name}-tf-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = {
        Service = "codebuild.amazonaws.com"
        AWS = [
          "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
          aws_iam_role.codebuild_role.arn
        ]
      }
      Action = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "tf_admin" {
  role       = aws_iam_role.tf_admin.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}
