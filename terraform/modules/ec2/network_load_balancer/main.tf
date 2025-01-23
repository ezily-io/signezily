resource "aws_lb_target_group" "instance" {
  name        = "${var.application}-lb-tg"
  port        = var.port
  protocol    = var.protocol
  target_type = "instance"
  vpc_id      = var.vpc_id
}

resource "aws_lb" "nlb" {
  name                             = "${var.application}-nlb"
  internal                         = var.internal
  load_balancer_type               = "network"
  security_groups                  = var.security_groups != [""] ? var.security_groups : null
  subnets                          = var.subnets
  enable_cross_zone_load_balancing = var.enable_cross_zone_load_balancing
}

resource "aws_lb_listener" "nlb" {
  load_balancer_arn = aws_lb.nlb.arn
  port              = var.port
  protocol          = var.protocol

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.instance.arn
  }
}