# Set variables
variable "route_table_id" {
  type        = string
  description = "Route Table ID"
}

variable "destination_ip" {
  type        = string
  description = "Destination IP"
}

variable "gateway_id" {
  type        = string
  description = "Gateway ID"
}
