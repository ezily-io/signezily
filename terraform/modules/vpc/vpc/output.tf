output "vpc" {
    value = aws_vpc.main_vpc
}

output "subnet_1" {
    value = aws_subnet.public_subnet_1
}

output "subnet_2" {
    value = aws_subnet.public_subnet_2
}

output "subnet_3" {
    value = aws_subnet.public_subnet_3
}

output "private_subnet_1" {
    value = aws_subnet.private_subnet_1
}

output "private_subnet_2" {
    value = aws_subnet.private_subnet_2
}

output "private_subnet_3" {
    value = aws_subnet.private_subnet_3
}