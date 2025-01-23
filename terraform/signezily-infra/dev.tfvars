image           = "898622234277.dkr.ecr.ap-northeast-1.amazonaws.com/signezily:app_latest"
marketing_image = "898622234277.dkr.ecr.ap-northeast-1.amazonaws.com/signezily:marketing_latest"
docs_image      = "898622234277.dkr.ecr.ap-northeast-1.amazonaws.com/signezily:docs_latest"
application     = "signezily"
environment     = "dev"
service_name    = "app"

# terraform workspace list
# terraform workspace select service-documenso-dev
# terraform plan -var-file=dev.tfvars
# terraform apply -var-file=dev.tfvars --auto-approve