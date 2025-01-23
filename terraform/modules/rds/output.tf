output "db_host" {
  value       = aws_db_instance.postgres.address
  sensitive   = true
}

output "db_password" {
  value       = random_password.random_password.result
  sensitive   = true
}

output "secrets" {
  value     = aws_secretsmanager_secret.aws_secretsmanager_secret_rds.id
  sensitive = true
}