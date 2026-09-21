variable "project_name" {

}

variable "docdb_username" {
}

variable "docdb_endpoint" {

}

variable "docdb_instance_dependency" {
  description = "Dependency trigger to ensure DocumentDB cluster instances are fully ready"
  type        = any
  default     = null
}

variable "site_domain" {
  description = "website full domain name"
}