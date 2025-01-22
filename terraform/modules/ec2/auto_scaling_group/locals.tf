# If the variable 'ami' is empty, then Ubuntu is selected.
locals {
  ami = var.ami != "" ? var.ami : data.aws_ami.ubuntu.id
}