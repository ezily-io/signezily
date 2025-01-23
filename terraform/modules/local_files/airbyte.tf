resource "local_file" "airbyte" {
  filename = "${var.path}/scripts/airbyte.sh"
  file_permission = "755"
  lifecycle {
    ignore_changes = all
  }
  content = <<-EOT
#!/bin/bash

# Install Docker
sudo apt-get update
sudo apt-get install ca-certificates \
  curl \
  gnupg \
  lsb-release -y

sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

sudo apt-get update

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get install docker-ce \
  docker-ce-cli \
  containerd.io \
  docker-buildx-plugin \
  docker-compose-plugin -y

# Install Airbyte
mkdir /opt/airbyte
cd /opt/airbyte
sudo apt-get install wget -y
wget https://raw.githubusercontent.com/airbytehq/airbyte-platform/main/{.env,flags.yml,docker-compose.yaml}

# Configure environment variables
sudo echo VERSION=${var.airbyte_version} >> /opt/airbyte/.env
DATABASE_USER=postgres
sudo echo DATABASE_PASSWORD=${var.db_password} >> /opt/airbyte/.env
sudo echo DATABASE_HOST=${var.db_host} >> /opt/airbyte/.env
sudo echo DATABASE_PORT=5432 >> /opt/airbyte/.env
sudo echo DATABASE_DB=postgres >> /opt/airbyte/.env
sudo echo DATABASE_URL=jdbc:postgresql://${var.db_host}:5432/postgres?ssl=true&sslmode=require >> /opt/airbyte/.env

# Execute Airbyte
docker compose up -d
  EOT
}