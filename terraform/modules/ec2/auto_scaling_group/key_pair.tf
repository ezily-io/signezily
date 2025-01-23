# Create a new SSH key
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

# Random string for secrets
resource "random_string" "random" {
  length           = 8
  special          = false
}

# Upload public key to EC2
resource "aws_key_pair" "server_key" {
  key_name   = "${var.application}_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

# Store the private key in Secrets Manager
resource "aws_secretsmanager_secret" "app_secret" {
  name = "${var.application}_ssh_key_${random_string.random.result}"
}

resource "aws_secretsmanager_secret_version" "app_secret_version" {
  secret_id     = aws_secretsmanager_secret.app_secret.id
  secret_string = tls_private_key.ssh_key.private_key_pem
}