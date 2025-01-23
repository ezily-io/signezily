output "groups_all_to_everywhere" {
  value = aws_security_group.allow_all_to_everywhere
}

output "groups_from_intranet" {
  value = aws_security_group.allow_all_from_intranet
}

output "groups_all_to_intranet" {
  value = aws_security_group.allow_from_intranet
}

output "groups_allow_from_everywhere" {
  value = aws_security_group.allow_from_everywhere
}