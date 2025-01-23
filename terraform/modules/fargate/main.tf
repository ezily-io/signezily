resource "aws_ecs_service" "main_given_task" {
  name = local.name

  cluster         = var.cluster_id
  task_definition = var.ecs_task_definition_arn
  #launch_type     = "FARGATE"
  desired_count   = var.desired_count

  dynamic "capacity_provider_strategy" {
    for_each = var.dynamic_capacity_provider_strategy

    content {
      capacity_provider = capacity_provider_strategy.value.capacity_provider
      weight            = capacity_provider_strategy.value.weight
      base              = capacity_provider_strategy.value.base
    }
  }

  deployment_controller {
    type = "ECS"
  }

  dynamic "load_balancer" {
    for_each = {
      for port in local.ports : port.lb => port
    }

    content {
      target_group_arn = aws_lb_target_group.main[load_balancer.value.host].arn
      container_name   = load_balancer.value.container
      container_port   = load_balancer.value.internal
    }
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.marketing_site_tg.arn
    container_name   = "marketing"
    container_port   = 3001
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.documentation_site_tg.arn
    container_name   = "documentation"
    container_port   = 3002
  }

  network_configuration {
    subnets          = var.ecs_subnet_ids
    security_groups  = [aws_security_group.ecs_tasks.id]
    assign_public_ip = var.assign_public_ip
  }

  lifecycle {
    ignore_changes = [
      # We anticipate this value changing due to autoscaling events
      desired_count,
    ]
  }

  depends_on = [aws_lb.main]
}