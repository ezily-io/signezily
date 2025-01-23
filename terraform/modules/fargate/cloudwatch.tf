resource "aws_cloudwatch_log_group" "tasks" {
  count = var.awslogs_group != null ? 1 : 0
  name  = local.awslogs_group

  retention_in_days = 90
}