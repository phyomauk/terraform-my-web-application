variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "docdb_subnet_ids" {
  type = list(string)
}

variable "docdb_sg_id" {

}

variable "ecs_sg_id" {
  type = string
}

variable "master_username" {
  type = string
}

variable "master_password" {
  type      = string
  sensitive = true
}

variable "instance_class" {
  type    = string
  default = "db.t3.medium"
}