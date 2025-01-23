data "aws_region" "current" {}

data "aws_subnet" "lb_subnets" {
  for_each = {
    for idx, subnet_id in var.lb_subnet_ids : idx => subnet_id
  }

  id = each.value
}