data "aws_route_table" "selected" {
    for_each = toset(var.subnet_ids)
    subnet_id = each.key
}
