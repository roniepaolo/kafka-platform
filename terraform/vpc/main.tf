# Creating VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.ip
  enable_dns_support   = var.dns_support
  enable_dns_hostnames = var.dns_hostnames

  tags = {
    Name = var.tag_name
  }
}
