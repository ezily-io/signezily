# Subnet declarations
# x.x.0.0/18 - AZ 1
#   x.x.0.0/20 - Private subnet
#   x.x.16.0/21 - Public subnet
#   x.x.24.0/21 - Spare
#   x.x.32.0/19 - Spare
# x.x.64.0/18 - AZ 2
#   x.x.64.0/20 - Private subnet
#   x.x.80.0/21 - Public subnet
#   x.x.88.0/21 - Spare
#   x.x.96.0/19 - Spare
# x.x.128.0/18 - AZ 3
#   x.x.128.0/20 - Private subnet
#   x.x.144.0/21 - Public subnet
#   x.x.152.0/21 - Spare
#   x.x.160.0/19 - Spare
# x.x.192.0/18 - Spare

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block = var.cidr
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name}_vpc"
  }
}

# Create a VPC endpoint for S3
resource "aws_vpc_endpoint" "s3" {
  vpc_id       = aws_vpc.main_vpc.id
  service_name = "com.amazonaws.${var.region}.s3"
}

# Create a public subnet 1
resource "aws_subnet" "public_subnet_1" {
  vpc_id = aws_vpc.main_vpc.id
  availability_zone = data.aws_availability_zones.available.names[0]
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 5, 2)
  map_public_ip_on_launch = true
  tags = {
    Name = "public_1_${data.aws_availability_zones.available.names[0]}",
    public = "true"
  }
}

# Create a public subnet 2
resource "aws_subnet" "public_subnet_2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 5, 10)
  map_public_ip_on_launch = true
  tags = {
    Name = "public_2_${data.aws_availability_zones.available.names[1]}",
    public = "true"
  }
}

# Create a public subnet 3
resource "aws_subnet" "public_subnet_3" {
  availability_zone = data.aws_availability_zones.available.names[2]
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 5, 18)
  map_public_ip_on_launch = true
  tags = {
    Name = "public_3_${data.aws_availability_zones.available.names[2]}",
    public = "true"
  }
}

# Create a private subnet 1
resource "aws_subnet" "private_subnet_1" {
  availability_zone = data.aws_availability_zones.available.names[0]
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 4, 0)
  map_public_ip_on_launch = false
  tags = {
    Name = "private_1_${data.aws_availability_zones.available.names[0]}",
    public = "false"
  }
}

# Create a private subnet 2
resource "aws_subnet" "private_subnet_2" {
  availability_zone = data.aws_availability_zones.available.names[1]
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 4, 4)
  map_public_ip_on_launch = false
  tags = {
    Name = "private_2_${data.aws_availability_zones.available.names[1]}",
    public = "false"
  }
}

# Create a private subnet 3
resource "aws_subnet" "private_subnet_3" {
  availability_zone = data.aws_availability_zones.available.names[2]
  vpc_id = aws_vpc.main_vpc.id
  cidr_block = cidrsubnet(aws_vpc.main_vpc.cidr_block, 4, 8)
  map_public_ip_on_launch = false
  tags = {
    Name = "private_3_${data.aws_availability_zones.available.names[2]}",
    public = "false"
  }
}

# Create an internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main_vpc.id
}

# Elastic IP for NAT gateway 1
resource "aws_eip" "eip_1" {
  vpc      = true
  tags = {
    Name = "eip_subnet_1"
  }
}

# Elastic IP for NAT gateway 2
resource "aws_eip" "eip_2" {
  vpc      = true
  tags = {
    Name = "eip_subnet_2"
  }
}

# Elastic IP for NAT gateway 3
resource "aws_eip" "eip_3" {
  vpc      = true
  tags = {
    Name = "eip_subnet_3"
  }
}

# Create a NAT gateway 1
resource "aws_nat_gateway" "ngw_1" {
  allocation_id     = aws_eip.eip_1.id
  subnet_id         = aws_subnet.public_subnet_1.id
  depends_on        = [aws_internet_gateway.igw]
  tags = {
    Name = "nat_gw_subnet_1"
  }
}

# Create a NAT gateway 2
resource "aws_nat_gateway" "ngw_2" {
  allocation_id     = aws_eip.eip_2.id
  subnet_id         = aws_subnet.public_subnet_2.id
  depends_on        = [aws_internet_gateway.igw]
  tags = {
    Name = "nat_gw_subnet_2"
  }
}

# Create a NAT gateway 3
resource "aws_nat_gateway" "ngw_3" {
  allocation_id     = aws_eip.eip_3.id
  subnet_id         = aws_subnet.public_subnet_3.id
  depends_on        = [aws_internet_gateway.igw]
  tags = {
    Name = "nat_gw_subnet_3"
  }
}

# Create a route table for the public subnets
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "public_rt"
  }
}

# Create a route table for the private subnet 1
resource "aws_route_table" "private_rt_1" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_1.id
  }
  tags = {
    Name = "private_rt_1"
  }
}

# Create a route table for the private subnet 2
resource "aws_route_table" "private_rt_2" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_2.id
  }
  tags = {
    Name = "private_rt_2"
  }
}

# Create a route table for the private subnet 3
resource "aws_route_table" "private_rt_3" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.ngw_3.id
  }
  tags = {
    Name = "private_rt_3"
  }
}

# Associate the public subnet 1 with the route table
resource "aws_route_table_association" "public_association_1" {
  subnet_id = aws_subnet.public_subnet_1.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate the public subnet 2 with the route table
resource "aws_route_table_association" "public_association_2" {
  subnet_id = aws_subnet.public_subnet_2.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate the public subnet 3 with the route table
resource "aws_route_table_association" "public_association_3" {
  subnet_id = aws_subnet.public_subnet_3.id
  route_table_id = aws_route_table.public_rt.id
}

# Associate the private subnet 1 with the route table
resource "aws_route_table_association" "private_association_1" {
  subnet_id = aws_subnet.private_subnet_1.id
  route_table_id = aws_route_table.private_rt_1.id
}

# Associate the private subnet 2 with the route table
resource "aws_route_table_association" "private_association_2" {
  subnet_id = aws_subnet.private_subnet_2.id
  route_table_id = aws_route_table.private_rt_2.id
}

# Associate the private subnet 3 with the route table
resource "aws_route_table_association" "private_association_3" {
  subnet_id = aws_subnet.private_subnet_3.id
  route_table_id = aws_route_table.private_rt_3.id
}

# RDS subnet group
resource "aws_db_subnet_group" "rds" {
  name       = "main"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id
  ]
}

# Elasticache subnet group
resource "aws_elasticache_subnet_group" "elasticache" {
  name       = "main"
  subnet_ids = [
    aws_subnet.private_subnet_1.id,
    aws_subnet.private_subnet_2.id,
    aws_subnet.private_subnet_3.id
  ]
}