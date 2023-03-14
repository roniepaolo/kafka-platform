# Creating VPC
module "vpc" {
  source        = "../vpc"
  ip            = "172.31.0.0/16"
  dns_support   = true
  dns_hostnames = true
  tag_name      = "prod"
}

# Creating Subnet in VPC
module "subnet" {
  source    = "../subnet"
  vpc_id    = module.vpc.vpc_id
  ip        = "172.31.1.0/24"
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
resource "aws_security_group" "security_group_in_out" {
  name        = "allow_list_in_out"
  description = "Allow list of IPs for connection in and out purpose"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "SSH connection"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  
  tags = {
    Name = "allow_list_in_out"
  }
}

resource "aws_security_group" "security_group_kafka" {
  name        = "allow_list_kafka"
  description = "Allow list of IPs for Kafka"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Kafka brokers"
    from_port   = 9092
    to_port     = 9093
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.0/24"]
  }

  tags = {
    Name = "allow_list_kafka"
  }
}

resource "aws_security_group" "security_group_spc1" {
  name        = "allow_list_spc1"
  description = "Allow list of IPs for spc1"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Schema Registry"
    from_port   = 8081
    to_port     = 8081
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.0/24"]
  }

  ingress {
    description = "Kafka Connect"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.0/24"]
  }

  ingress {
    description = "Bento"
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.0/24"]
  }

  tags = {
    Name = "allow_list_spc1"
  }
}

resource "aws_security_group" "security_group_spc2" {
  name        = "allow_list_spc2"
  description = "Allow list of IPs for spc2"
  vpc_id      = module.vpc.vpc_id

  ingress {
    description = "Kafka Connect"
    from_port   = 8083
    to_port     = 8083
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.0/24"]
  }

  ingress {
    description = "Postgres"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["172.31.1.0/24"]
  }

  ingress {
    description = "Full-stack http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Full-stack https"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_list_spc2"
  }
}

# Creating Key Pair
module "auth" {
  source   = "../key_pair"
  key_name = "prod-key"
  key_path = file("~/.ssh/id_ed25519.pub")
}

# Creating EC2 instance
module "ec2_kafka" {
  count         = 3
  source        = "../ec2"
  instance_type = "t3a.medium"
  ami           = data.aws_ami.ami.id
  az            = "us-east-1a"
  key_name      = module.auth.key_pair_id
  sgs           = [aws_security_group.security_group_in_out.id, aws_security_group.security_group_kafka.id]
  subnet_id     = module.subnet.subnet_id
  tag_name      = "gen${count.index + 1}"
}

# Creating EBS for EC2
module "ebs_kafka" {
  count    = 3
  source   = "../ebs"
  az       = "us-east-1a"
  size     = 10
  tag_name = "gen${count.index + 1}"
}

# Creating EC2 instance
module "ec2_spc1" {
  source        = "../ec2"
  instance_type = "t3a.medium"
  ami           = data.aws_ami.ami.id
  az            = "us-east-1a"
  key_name      = module.auth.key_pair_id
  sgs           = [aws_security_group.security_group_in_out.id, aws_security_group.security_group_spc1.id]
  subnet_id     = module.subnet.subnet_id
  tag_name      = "spc1"
}

# Creating EC2 instance
module "ec2_spc2" {
  source        = "../ec2"
  instance_type = "t3a.medium"
  ami           = data.aws_ami.ami.id
  az            = "us-east-1a"
  key_name      = module.auth.key_pair_id
  sgs           = [aws_security_group.security_group_in_out.id, aws_security_group.security_group_spc2.id]
  subnet_id     = module.subnet.subnet_id
  tag_name      = "spc2"
}

# Creating EBS for EC2
module "ebs_spc" {
  count    = 2
  source   = "../ebs"
  az       = "us-east-1a"
  size     = 10
  tag_name = "spc${count.index + 1}"
}

# Attaching EBS to EC2
resource "aws_volume_attachment" "ebs_att_kafka" {
  count       = 3
  device_name = "/dev/sdh"
  volume_id   = module.ebs_kafka.*.ebs_id[count.index]
  instance_id = module.ec2_kafka.*.ec2_id[count.index]
}

# Attaching EBS to EC2
resource "aws_volume_attachment" "ebs_att_spc1" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs_spc.*.ebs_id[0]
  instance_id = module.ec2_spc1.ec2_id
}

# Attaching EBS to EC2
resource "aws_volume_attachment" "ebs_att_spc2" {
  device_name = "/dev/sdh"
  volume_id   = module.ebs_spc.*.ebs_id[1]
  instance_id = module.ec2_spc2.ec2_id
}
