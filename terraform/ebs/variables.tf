# Set variables
variable "az" {
  type        = string
  description = "Availability Zone for EBS"
}

variable "size" {
  type        = number
  description = "Size of EBS"
}

variable "tag_name" {
  type        = string
  description = "Tag name for EBS"
}
