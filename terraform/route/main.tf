# Creating route entry in Routing Table
resource "aws_route" "route" {
  route_table_id         = var.route_table_id
  destination_cidr_block = var.destination_ip
  gateway_id             = var.gateway_id
}
