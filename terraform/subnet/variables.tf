# Set variables
variable "vpc_id" {
  type        = string
  description = "VPC ID where subnet will exist"
}

variable "ip" {
  type        = string
  description = "Subnet private IP"
}

variable "public_ip" {
  type        = string
  description = "If public IP is assigned in every launched instance"
}

variable "az" {
  type        = string
  description = "Availability zone for subnet"
}

variable "tag_name" {
  type        = string
  description = "Tag name for subnet"
}

