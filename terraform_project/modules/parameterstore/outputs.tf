output "username_parameter_name" {
  value = aws_ssm_parameter.docdb_username.name
}

output "password_parameter_name" {
  value = aws_ssm_parameter.docdb_password.name
}

output "username_parameter_arn" {
  value = aws_ssm_parameter.docdb_username.arn
}

output "password_parameter_arn" {
  value = aws_ssm_parameter.docdb_password.arn
}

output "docdb_username" {
  value     = aws_ssm_parameter.docdb_username.value
  sensitive = true
}

output "docdb_password" {
  value     = aws_ssm_parameter.docdb_password.value
  sensitive = true
}

output "docdb_uri" {
  value = aws_ssm_parameter.docdb_uri.value
}

output "docdb_uri_arn" {
  value = aws_ssm_parameter.docdb_uri.arn
}

output "cert_arn" {
  value = aws_ssm_parameter.cert_arn.value
}