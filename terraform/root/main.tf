# Creating VPC
module "vpc" {
  source        = "../vpc"
  ip            = "10.0.0.0/16"
  dns_support   = true
  dns_hostnames = true
  tag_name      = "prod"
}

# Creating Subnet in VPC
module "subnet" {
  source    = "../subnet"
  vpc_id    = module.vpc.vpc_id
  ip        = "10.0.1.0/24"
  public_ip = true
  az        = "us-east-1a"
  tag_name  = "prod-1"
}

# Creating Internet Gateway in VPC
module "igw" {
  source   = "../igw"
  vpc_id   = module.vpc.vpc_id
  tag_name = "prod-igw"
}

# Creating Route Table
module "route_table" {
  source   = "../route_table"
  vpc_id   = module.vpc.vpc_id
  tag_name = "prod-rt"
}

# Creating Route
module "route" {
  source         = "../route"
  route_table_id = module.route_table.route_table_id
  destination_ip = "0.0.0.0/0"
  gateway_id     = module.igw.igw_id
}

# Creating association between Route Table and Subnet
resource "aws_route_table_association" "public_assoc" {
  subnet_id      = module.subnet.subnet_id
  route_table_id = module.route_table.route_table_id
}

# Creating Security Group with default rules
module "security_group" {
  source                    = "../sg"
  name                      = "allow_list_sg"
  description               = "Allow list of IPs who can enter server"
  vpc_id                    = module.vpc.vpc_id
  ingress_desc_default      = "SSH connection"
  ingress_from_port_default = 22
  ingress_to_port_default   = 22
  ingress_protocol_default  = "tcp"
  ingress_ipsv4_default     = ["0.0.0.0/0"]
  tag_name                  = "allow_list_sg"
}

# Creating Key Pair
module "auth" {
  source   = "../key_pair"
  key_name = "prod-key"
  key_path = file("~/.ssh/id_ed25519.pub")
}

# Creating EC2 instance
module "ec2" {
  source        = "../ec2"
  instance_type = "t3a.medium"
  ami           = data.aws_ami.ami.id
  az            = "us-east-1a"
  key_name      = module.auth.key_pair_id
  sgs           = [module.security_group.sg_id]
  subnet_id     = module.subnet.subnet_id
  tag_name      = "gen1"
}

# Creating EBS for EC2
module "ebs" {
  source   = "../ebs"
  az       = "us-east-1a"
  size     = 10
  tag_name = "gen1"
}

# Attaching EBS to EC2
resource "aws_volume_attachment" "ebs_att" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs.ebs_id
  instance_id = module.ec2.ec2_id
}
