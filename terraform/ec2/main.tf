# Create EC2 instance
resource "aws_instance" "ec2" {
  instance_type          = var.instance_type
  ami                    = var.ami
  availability_zone      = var.az
  key_name               = var.key_name
  vpc_security_group_ids = var.sgs
  subnet_id              = var.subnet_id

  tags = {
    Name = var.tag_name
  }
}
