# ------------------------------------------------------------------------------
# 1. Trust Policy Data Source for CodeDeploy
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "codedeploy_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codedeploy.amazonaws.com"]
    }
  }
}

# ------------------------------------------------------------------------------
# 2. IAM Role Creation
# ------------------------------------------------------------------------------
resource "aws_iam_role" "codedeploy_role" {
  name               = "${var.project_name}-codedeploy-ecs-role"
  assume_role_policy = data.aws_iam_policy_document.codedeploy_assume_role.json

  tags = {
    Name = "${var.project_name}-codedeploy-role"
  }
}

# ------------------------------------------------------------------------------
# 3. Managed Policy Attachment (AWSCodeDeployRoleForECS)
# ------------------------------------------------------------------------------
resource "aws_iam_role_policy_attachment" "codedeploy_ecs_policy" {
  role       = aws_iam_role.codedeploy_role.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeDeployRoleForECS"
}

# ------------------------------------------------------------------------------
# 4. Inline Policy for iam:PassRole (Required for ECS Execution & Task Roles)
# ------------------------------------------------------------------------------
data "aws_iam_policy_document" "passrole_policy" {
  statement {
    effect    = "Allow"
    actions   = ["iam:PassRole"]
    resources = [aws_iam_role.ecs_task_execution_role.arn]
  }
}

resource "aws_iam_role_policy" "codedeploy_passrole" {
  name   = "${var.project_name}-codedeploy-passrole"
  role   = aws_iam_role.codedeploy_role.id
  policy = data.aws_iam_policy_document.passrole_policy.json
}