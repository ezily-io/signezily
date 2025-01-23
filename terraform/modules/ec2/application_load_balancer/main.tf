resource "aws_lb_target_group" "ip" {
  name        = "${var.application}-lb-tg"
  port        = var.port
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb" "alb" {
  name               = "${var.application}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_groups
  subnets            = var.subnets
}

resource "aws_lb_listener" "alb_80" {
  load_balancer_arn = aws_lb.alb.arn
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

resource "aws_lb_listener" "alb_443" {
  load_balancer_arn = aws_lb.alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.acm_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ip.arn
  }
}

resource "aws_lb_listener_certificate" "alb_443" {
  for_each = {
    for cert in var.listener_certs_arns : cert.app => cert
    if var.additional_listener_certs
  }
  listener_arn    = aws_lb_listener.alb_443.arn
  certificate_arn = each.value.certificate_arn
}