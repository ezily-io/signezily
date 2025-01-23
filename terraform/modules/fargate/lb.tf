resource "aws_lb" "main" {
  name               = "${var.application_fullname}-${var.environment}"
  internal           = var.lb_internal
  load_balancer_type = var.network_lb ? "network" : "application"

  security_groups = var.network_lb ? [] : [aws_security_group.lb[0].id]
  subnets         = var.lb_subnet_ids
}

resource "aws_lb_target_group" "main" {
  for_each = {
    for port in local.ports : port.host => port
  }

  name        = "${local.name}-${each.key}"
  target_type = "ip"
  port        = each.key
  protocol    = var.network_lb ? "TCP" : "HTTP"
  vpc_id      = var.vpc_id

  lifecycle {
    create_before_destroy = true
  }

  dynamic "health_check" {
    for_each = var.network_lb ? [0] : []

    content {
      enabled  = lookup(each.value.health_check, "enabled", true)
      port     = lookup(each.value.health_check, "port", "traffic-port")
      protocol = "TCP"
    }
  }

  dynamic "health_check" {
    for_each = var.network_lb ? [] : [0]

    content {
      enabled  = lookup(each.value.health_check, "enabled", true)
      protocol = "HTTP"
      port     = lookup(each.value.health_check, "port", "traffic-port")
      path     = lookup(each.value.health_check, "path", "/")
    }
  }
}

resource "aws_lb_listener" "main" {
  for_each = {
    for port in local.ports : port.lb => port
  }

  load_balancer_arn = aws_lb.main.arn

  port     = each.key
  protocol = each.value.secure ? (var.network_lb ? "TLS" : "HTTPS") : (var.network_lb ? "TCP" : "HTTP")

  ssl_policy      = each.value.secure ? "ELBSecurityPolicy-2016-08" : null
  certificate_arn = each.value.secure ? var.certificate_arn : null

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main[each.value.host].arn
  }
}

resource "aws_lb_listener" "redirect" {
  count = contains(tolist(local.ports.*.redirect), true) == true ? 1 : 0
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_target_group" "marketing_site_tg" {
  name     = "${var.environment}-marketing-site-tg"
  target_type = "ip"
  port     = 3001
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = 3001
  }
}
resource "aws_lb_target_group" "documentation_site_tg" {
  name     = "${var.environment}-documentation-site-tg"
  target_type = "ip"
  port     = 3002
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path = "/"
    port = 3002
  }
}

resource "aws_lb_listener_rule" "marketing_site_rule" {
  # listener_arn = data.aws_lb_listener.default_listener_443.arn
  listener_arn = aws_lb_listener.main["443"].arn
  priority     = 200

  condition {
    host_header {
      values = ["sign.ezily.io"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.marketing_site_tg.arn
  }
  lifecycle {
    ignore_changes = [ condition ]
  }
  depends_on = [ aws_lb_listener.main ]
}

resource "aws_lb_listener_rule" "documentation_site_rule" {
  listener_arn = aws_lb_listener.main["443"].arn
  priority     = 201

  condition {
    host_header {
      values = ["docs.sign.ezily.io"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.documentation_site_tg.arn
  }
  lifecycle {
    ignore_changes = [ condition ]
  }
  depends_on = [ aws_lb_listener.main ]
}