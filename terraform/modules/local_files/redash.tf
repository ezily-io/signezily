resource "local_file" "redash" {
  filename = "${var.path}/scripts/redash.sh"
  file_permission = "755"
  lifecycle {
    ignore_changes = all
  }
  content = <<-EOF
#!/bin/bash

sudo cat <<EOT >> /opt/redash/docker-compose.yml
version: "2"
x-redash-service: &redash-service
  image: redash/redash:10.0.0.b50363
  depends_on:
    - redis
  env_file: /opt/redash/env
  restart: always
services:
  server:
    <<: *redash-service
    command: server
    ports:
      - "5000:5000"
    environment:
      REDASH_WEB_WORKERS: 4
  scheduler:
    <<: *redash-service
    command: scheduler
  scheduled_worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "scheduled_queries schemas"
      WORKERS_COUNT: 2
  adhoc_worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "queries"
      WORKERS_COUNT: 2
  worker:
    <<: *redash-service
    command: worker
    environment:
      QUEUES: "periodic emails default"
      WORKERS_COUNT: 1
  redis:
    image: redis:5.0-alpine
    restart: always
  nginx:
    image: redash/nginx:latest
    ports:
      - "80:80"
    depends_on:
      - server
    links:
      - server:redash
    restart: always
EOT

sudo echo REDASH_DATABASE_URL=postgresql://postgres:${var.db_password}@${var.db_host}/redash >> /opt/redash/env

cd /opt/redash

sudo docker-compose up --force-recreate --build -d
docker-compose run --rm server create_db
docker-compose run --rm server manage db upgrade

  EOF
}