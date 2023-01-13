# Creating EBS for EC2
resource "aws_ebs_volume" "ebs" {
  availability_zone = var.az
  size              = var.size

  tags = {
    Name = var.tag_name
  }
}
