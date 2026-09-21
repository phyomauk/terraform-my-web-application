resource "aws_docdb_cluster_parameter_group" "this" {
  family = "docdb5.0"
  name   = "${var.project_name}-docdb-params"

  parameter {
    name  = "tls"
    value = "enabled"
  }
}

# DocumentDB Subnet Group
resource "aws_docdb_subnet_group" "this" {
  name        = "${var.project_name}-docdb-subnet-group"
  description = "Dedicated subnet group for DocumentDB"

  subnet_ids = var.docdb_subnet_ids

  tags = {
    Name = "${var.project_name}-docdb-subnet-group"
  }
}

resource "aws_docdb_cluster" "this" {
  cluster_identifier = "${var.project_name}-docdb"

  engine = "docdb"

  master_username = var.master_username
  master_password = var.master_password

  db_subnet_group_name   = aws_docdb_subnet_group.this.name
  vpc_security_group_ids = [var.docdb_sg_id]

  db_cluster_parameter_group_name = aws_docdb_cluster_parameter_group.this.name

  ### 
  # Speed up destruction in development/lab environments
  skip_final_snapshot     = true
  deletion_protection     = false
  backup_retention_period = 1
  ###

  tags = {
    Name = "${var.project_name}-docdb"
  }
}

resource "aws_docdb_cluster_instance" "this" {
  identifier         = "${var.project_name}-docdb-1"
  cluster_identifier = aws_docdb_cluster.this.id

  instance_class = var.instance_class

  tags = {
    Name = "${var.project_name}-docdb-1"
  }
}