data "aws_ami" "server-ami" {
  most_recent = true

  owners = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }
}

resource "random_id" "mtc-node-id" {
  byte_length = 2
  count       = var.instance_count
  keepers = {
    key_name = var.key_name
  }
}

resource "aws_key_pair" "mtc-auth" {
  key_name   = var.key_name
  public_key = var.public_key_material
}

resource "aws_instance" "mtc-node" {
  count         = var.instance_count
  instance_type = var.instance_type
  ami           = data.aws_ami.server-ami.id

  tags = {
    Name = "mtc-node-${random_id.mtc-node-id[count.index].dec}"
  }

  key_name               = aws_key_pair.mtc-auth.id
  vpc_security_group_ids = [var.public_sg]
  subnet_id              = var.public_subnets[count.index]

  root_block_device {
    volume_size = var.vol_size
  }
}
