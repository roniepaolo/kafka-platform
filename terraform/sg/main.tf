# Creating Secutiy Group
resource "aws_security_group" "security_group" {
  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  ingress {
    description = var.ingress_desc_default
    from_port   = var.ingress_from_port_default
    to_port     = var.ingress_to_port_default
    protocol    = var.ingress_protocol_default
    cidr_blocks = var.ingress_ipsv4_default
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = var.tag_name
  }
}
