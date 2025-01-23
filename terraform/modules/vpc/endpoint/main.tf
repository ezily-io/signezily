
# Create a VPC endpoint for ECR API endpoint for pulling image metadata
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.api"
  vpc_endpoint_type = "Interface"
  security_group_ids    = var.security_group_ids
  subnet_ids        = var.subnet_ids
  private_dns_enabled = true
  tags = {
    Name = "ECR API"
  }
}

# Create a VPC endpoint for ECR DKR endpoint for pulling container images from ECR
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.ecr.dkr"
  vpc_endpoint_type = "Interface"
  security_group_ids    = var.security_group_ids
  subnet_ids        = var.subnet_ids
  private_dns_enabled = true
  tags = {
    Name = "ECR DKR"
  }
}

resource "aws_vpc_endpoint" "ecr_s3" {
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  route_table_ids   = local.private_route_table_ids
  vpc_endpoint_type = "Gateway"

  policy = <<POLICY
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Action": "*",
      "Effect": "Allow",
      "Resource": "*",
      "Principal": "*"
    }
  ]
}
POLICY

  tags = {
    Name = "ECR S3"
  }
}