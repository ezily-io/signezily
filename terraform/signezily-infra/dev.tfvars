docker_image_tag = "latest"
application      = "signezily"
environment      = "dev"
service_name     = "app"

# terraform workspace list
# terraform workspace select service-documenso-dev
# terraform plan -var-file=dev.tfvars
# terraform apply -var-file=dev.tfvars --auto-approve