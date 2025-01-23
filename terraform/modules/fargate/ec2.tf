resource "aws_security_group" "lb" {
  count = var.network_lb ? 0 : 1

  name        = "${local.name}-ecs-alb"
  description = "controls access to the ALB"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "lb_ingress" {
  for_each = {
    for port in local.ports : port.lb => port
    if !var.network_lb
  }

  security_group_id = aws_security_group.lb[0].id

  type        = "ingress"
  from_port   = each.key
  to_port     = each.key
  protocol    = each.value.protocol
  cidr_blocks = ["0.0.0.0/0"]

  description = "Ingress to LB from ${each.key} (${each.value.container}:${each.value.internal}:${each.value.host})"
}

resource "aws_security_group_rule" "lb_redirect" {
  count = contains(tolist(local.ports.*.redirect), true) == true ? 1 : 0
  security_group_id = aws_security_group.lb[0].id

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "TCP"
  cidr_blocks = ["0.0.0.0/0"]

  description = "Ingress to LB from 80"
}

# Traffic to the ECS Cluster should only come from the ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "${local.name}-ecs-tasks"
  description = "allow inbound access from the ALB only"
  vpc_id      = var.vpc_id

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "ecs_tasks_ingress" {
  for_each = {
    for port in local.ports : port.host => port
    if !var.network_lb
  }

  security_group_id = aws_security_group.ecs_tasks.id

  type                     = "ingress"
  from_port                = each.key
  to_port                  = each.key
  protocol                 = each.value.protocol
  source_security_group_id = aws_security_group.lb[0].id

  description = "LB to Task:${each.key} (${each.value.container}:${each.value.internal}:${each.value.host})"
}

resource "aws_security_group_rule" "ecs_tasks_ingress_network" {
  for_each = {
    for port in local.ports : port.host => port
    if var.network_lb
  }

  security_group_id = aws_security_group.ecs_tasks.id

  type      = "ingress"
  from_port = each.key
  to_port   = each.key
  protocol  = each.value.protocol

  cidr_blocks = [
    for subnet in data.aws_subnet.lb_subnets : subnet.cidr_block
  ]

  description = "LB Subnets to Task:${each.key} (${each.value.container}:${each.value.internal}:${each.value.host})"
}