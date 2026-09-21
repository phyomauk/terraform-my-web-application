# this moudule will be called during infrastructure provisioning 

resource "random_password" "docdb" {
  length  = 16
  special = false
}

resource "aws_ssm_parameter" "docdb_username" {
  name  = "/${var.project_name}/docdb/username"
  type  = "String"
  value = var.docdb_username
}

resource "aws_ssm_parameter" "docdb_password" {
  name  = "/${var.project_name}/docdb/password"
  type  = "SecureString"
  value = random_password.docdb.result

  lifecycle {
    ignore_changes = [value]
  }
}

resource "aws_ssm_parameter" "docdb_uri" {
  name        = "/${var.project_name}/docdb/uri"
  type        = "SecureString"
  value       = "mongodb://${var.docdb_username}:${random_password.docdb.result}@${var.docdb_endpoint}:27017/commentsdb?authSource=admin&tls=true&replicaSet=rs0&readPreference=secondaryPreferred&retryWrites=false&authMechanism=SCRAM-SHA-1"
  description = "DocumentDB full connection string for Node.js backend"

  # Force SSM parameter creation to wait for DocumentDB instance readiness
  depends_on = [
    var.docdb_instance_dependency
  ]

  lifecycle {
    ignore_changes = [value]
  }
}

data "aws_acm_certificate" "existing" {
  domain   = var.site_domain
  statuses = ["ISSUED"]
}

resource "aws_ssm_parameter" "cert_arn" {
  name  = "/${var.project_name}/prod/certificate_arn"
  type  = "String"
  value = data.aws_acm_certificate.existing.arn
}