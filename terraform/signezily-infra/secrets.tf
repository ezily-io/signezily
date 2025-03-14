# Credentials Secret
resource "aws_secretsmanager_secret" "signezily" {
  name                    = "${var.environment}/${var.application}"
  recovery_window_in_days = 0
}

# Secret Version
resource "aws_secretsmanager_secret_version" "sversion" {
  secret_id     = aws_secretsmanager_secret.signezily.id
  secret_string = <<EOF
   {
    "": "",
   }
EOF
  lifecycle {
    ignore_changes = [secret_string]
  }
}