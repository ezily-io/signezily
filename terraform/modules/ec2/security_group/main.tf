
resource "aws_security_group" "sg" {
  name        = "${var.name}"
  description = "controls access to the ${var.name}"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group_rule" "sg_ingress" {
  for_each = {
    for port in var.ports : port.from_port => port
  }

  security_group_id = aws_security_group.sg.id

  type        = "ingress"
  from_port   = each.value.from_port
  to_port     = each.value.to_port
  protocol    = each.value.protocol
  cidr_blocks = each.value.cidr_blocks

  description = "Ingress from ${each.key})"
}