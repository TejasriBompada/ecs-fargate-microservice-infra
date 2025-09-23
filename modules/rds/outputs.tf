output "rds_endpoint" {
  description = "RDS instance endpoint"
  value       = aws_db_instance.this.endpoint
}

output "rds_arn" {
  description = "ARN of RDS instance"
  value       = aws_db_instance.this.arn
}

output "rds_secret_arn" {
  description = "ARN of the secret storing DB credentials"
  value       = aws_secretsmanager_secret.rds.arn
}

output "rds_secret_name" {
  description = "Name of the secret storing DB credentials"
  value       = aws_secretsmanager_secret.rds.name
}
