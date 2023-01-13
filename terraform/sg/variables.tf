# Set variables
variable "name" {
  type        = string
  description = "Name of SG"
}

variable "description" {
  type        = string
  description = "Description of SG"
}

variable "vpc_id" {
  type        = string
  description = "VPC where SG lives"
}

variable "ingress_desc_default" {
  type        = string
  description = "Ingress rul description"
}

variable "ingress_from_port_default" {
  type        = string
  description = "From port"
}

variable "ingress_to_port_default" {
  type        = string
  description = "To port"
}

variable "ingress_protocol_default" {
  type        = string
  description = "Protocol"
}

variable "ingress_ipsv4_default" {
  type        = list(string)
  description = "IPs v4"
}

variable "tag_name" {
  type        = string
  description = "Name tag"
}

