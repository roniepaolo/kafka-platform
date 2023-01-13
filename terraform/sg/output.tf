# Returns of Security Group creation module
output "sg_id" {
  value = aws_security_group.security_group.id
}
