# Set variables
variable "instance_type" {
  type        = string
  description = "EC2 instance type"
}

variable "ami" {
  type        = string
  description = "AMI of EC2 instance"
}

variable "az" {
  type        = string
  description = "Availability zone of EC2"
}

variable "key_name" {
  type        = string
  description = "Key Pair name of EC2"
}

variable "sgs" {
  type        = list(string)
  description = "Security Groups of EC2"
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID of EC2"
}

variable "tag_name" {
  type        = string
  description = "EC2 tag name"
}
