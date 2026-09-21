output "cluster_endpoint" {
  value = aws_docdb_cluster.this.endpoint
}

output "reader_endpoint" {
  value = aws_docdb_cluster.this.reader_endpoint
}

output "cluster_id" {
  value = aws_docdb_cluster.this.id
}

output "cluster_arn" {
  value = aws_docdb_cluster.this.arn
}
