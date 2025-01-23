output "lb_arn" {
  value = aws_lb.main.arn
}

output "lb_arn_suffix" {
  value = aws_lb.main.arn_suffix
}

output "lb_zone_id" {
  value = aws_lb.main.zone_id
}

output "lb_dns_name" {
  value = aws_lb.main.dns_name
}

output "lb_listener_arns" {
  value = aws_lb_listener.main
}

output "task_security_group_id" {
  value = aws_security_group.ecs_tasks.id
}

output "target_group_arns" {
  value = aws_lb_target_group.main.*
}

output "zone_id" {
  value = aws_lb.main.zone_id
}

output "dns_name" {
  value = aws_lb.main.dns_name
}