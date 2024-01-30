data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}




resource "aws_instance" "private_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.private_instance_type
  subnet_id     = var.edu_subnet_private_id
}

resource "aws_instance" "public_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.public_instance_type
  subnet_id     = var.edu_subnet_public_id
}
