# RDS Instance Running Postgres
resource "aws_db_instance" "postgres" {
  allocated_storage         = 20
  max_allocated_storage     = 100
  publicly_accessible       = false
  engine                    = "postgres"
  engine_version            = "13.15"
  instance_class            = "db.t3.micro"
  db_name                   = var.application
  identifier_prefix         = "${var.environment}-${var.application}-"
  username                  = "postgres"
  password                  = random_password.random_password.result
  skip_final_snapshot       = false
  final_snapshot_identifier = "snapshot-${random_string.random_1.result}"
  db_subnet_group_name      = var.subnet_name
  vpc_security_group_ids    = var.security_groups
  backup_window             = "09:30-10:00"
  backup_retention_period   = "30"
  deletion_protection       = var.del_protect
}

# Create Random Password
resource "random_password" "random_password" {
  length                    = 16
  special                   = false
  min_lower                 = 3
  min_upper                 = 3
  min_numeric               = 3
}

# Database Random Name 1
resource "random_string" "random_1" {
  length                    = 24
  special                   = false
  min_lower                 = 24
}

# Secrets Random Name 2
resource "random_string" "random_2" {
  length                    = 24
  special                   = false
  min_numeric               = 6
  min_lower                 = 3
  min_upper                 = 3
}

# Credentials Secret
resource "aws_secretsmanager_secret" "aws_secretsmanager_secret_rds" {
   name                    = "${var.application}_rds_${random_string.random_2.result}"
   recovery_window_in_days = 0
}

# Secret Version #"db_host":
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id                = aws_secretsmanager_secret.aws_secretsmanager_secret_rds.id
  secret_string            = <<EOF
   {
    "username": "postgres",
    "password": "${random_password.random_password.result}",
    "host": "${aws_db_instance.postgres.address}"
   }
EOF
  lifecycle {
    ignore_changes = [secret_string]
  }
}