# Set variables
variable "ip" {
  type        = string
  description = "Private IP for VPC"
}

variable "dns_support" {
  type        = bool
  description = "Allow DNS support"
}

variable "dns_hostnames" {
  type        = bool
  description = "Allow DNS hostnames"
}

variable "tag_name" {
  type        = string
  description = "Tag name for VPC"
}
