locals {
    #description = "Subnets route_table to attach the s3 vpc endpoint."
    private_route_table_ids = [
        for route_table in data.aws_route_table.selected : route_table.id
    ]
}