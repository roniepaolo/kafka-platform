# Creating subnet
resource "aws_subnet" "subnet" {
  vpc_id                  = var.vpc_id
  cidr_block              = var.ip
  map_public_ip_on_launch = var.public_ip
  availability_zone       = var.az

  tags = {
    Name = var.tag_name
  }
}
