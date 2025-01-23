##
# intranet {
##

# inbound {

resource "aws_security_group" "allow_all_from_intranet" {
  name        = "allow_all_from_intranet"
  description = "Allow all from intranet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "All Inbound From Intranet (${local.vpc_name})"
  }
}

resource "aws_security_group_rule" "allow_all_from_intranet" {
  description = "Allow all from intranet"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.allow_all_from_intranet.id
}

resource "aws_security_group" "allow_from_intranet" {
  count       = length(local.inbound_intersection)
  name        = "allow_${lower(local.inbound_intersection[count.index])}_from_intranet"
  description = "Allow ${local.inbound_intersection[count.index]} from intranet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Inbound ${local.inbound_intersection[count.index]}"
  }
}

resource "aws_security_group_rule" "allow_from_intranet" {
  for_each = {
    for name, def in local.group_ports : def.key => def
    if contains(local.inbound_intersection, def.name)
  }

  description       = each.value.name
  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.allow_from_intranet[index(local.inbound_intersection, each.value.name)].id
}

# inbound }

# outbound {

resource "aws_security_group" "allow_all_to_intranet" {
  name        = "allow_all_to_intranet"
  description = "Allow all to intranet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "All Inbound To Intranet (${local.vpc_name})"
  }
}

resource "aws_security_group_rule" "allow_all_to_intranet" {
  description = "Allow all to intranet"
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = "all"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.allow_all_to_intranet.id
}

resource "aws_security_group" "allow_to_intranet" {
  count       = length(local.outbound_intersection)
  name        = "allow_${lower(local.outbound_intersection[count.index])}_to_intranet"
  description = "Allow ${local.outbound_intersection[count.index]} to intranet"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Outbound ${local.outbound_intersection[count.index]} To Intranet (${local.vpc_name})"
  }
}

resource "aws_security_group_rule" "allow_to_intranet" {
  for_each = {
    for name, def in local.group_ports : def.key => def
    if contains(local.outbound_intersection, def.name)
  }

  description       = each.value.name
  type              = "egress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = ["${var.vpc_cidr}"]
  security_group_id = aws_security_group.allow_to_intranet[index(local.outbound_intersection, each.value.name)].id
}

# outbound }

##
# intranet }
##

##
# everywhere {
##

# inbound {

resource "aws_security_group" "allow_from_everywhere" {
  for_each = {
    for name, def in local.groups : name => def
    if lookup(def, "public", false) && contains(local.public_inbound_intersection, name)
  }

  name        = "allow_${lower(each.key)}_from_everywhere"
  description = "Allow ${each.key} from everywhere"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Inbound ${each.key} From Everywhere (${local.vpc_name})"
  }
}

resource "aws_security_group_rule" "allow_from_everywhere" {
  for_each = {
    for name, def in local.group_ports : def.key => def
    if lookup(def, "public", false) && contains(local.public_inbound_intersection, def.name)
  }

  type              = "ingress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_from_everywhere[each.value.name].id
}

# inbound }

# outbound {

resource "aws_security_group" "allow_all_to_everywhere" {
  name        = "allow_all_to_everywhere"
  description = "Allow all to everywhere"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Outbound All To Everywhere (${local.vpc_name})"
  }
}

resource "aws_security_group_rule" "allow_all_to_everywhere" {
  type              = "egress"
  description       = "Allow all to everywhere"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_all_to_everywhere.id
}

resource "aws_security_group" "allow_to_everywhere" {
  for_each = {
    for name, def in local.groups : name => def
    if lookup(def, "public", false) && contains(local.public_outbound_intersection, name)
  }

  name        = "allow_${lower(each.key)}_to_everywhere"
  description = "Allow ${each.key} to everywhere"
  vpc_id      = var.vpc_id

  tags = {
    Name = "Outbound ${each.key} To Everywhere (${local.vpc_name})"
  }
}

resource "aws_security_group_rule" "allow_to_everywhere" {
  for_each = {
    for name, def in local.group_ports : def.key => def
    if lookup(def, "public", false) && contains(local.public_outbound_intersection, def.name)
  }

  type              = "egress"
  from_port         = each.value.port
  to_port           = each.value.port
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.allow_to_everywhere[each.value.name].id
}

# outbound }

##
# everywhere }
##