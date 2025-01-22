data "aws_vpcs" "prod" {
  tags = {
    Name = "production_vpc"
  }
}

data "aws_vpc" "prod" {
  id = data.aws_vpcs.prod.ids[0]
}

data "aws_subnets" "prod_public" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod.id]
  }
  filter {
    name   = "tag:public"
    values = ["true"]
  }
}

data "aws_subnets" "prod_private" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.prod.id]
  }
  filter {
    name   = "tag:public"
    values = ["false"]
  }
}

data "aws_db_subnet_group" "rds" {
  name = "main"
}

data "aws_security_groups" "postgres" {
  tags = {
    Automation = "Terraform"
    Name       = "Inbound Postgres"
  }
}

data "aws_security_groups" "outbound_everywhere" {
  tags = {
    Automation = "Terraform"
    Name       = "Outbound All To Everywhere (${data.aws_vpc.prod.id} AP-NORTHEAST-1)"
  }
}