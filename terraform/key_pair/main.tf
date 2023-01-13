# Creating Key Pair
resource "aws_key_pair" "auth" {
  key_name   = var.key_name
  public_key = var.key_path
}
