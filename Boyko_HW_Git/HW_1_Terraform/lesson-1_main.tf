resource "aws_vpc" "edu_hillel_vpc" {
  cidr_block = var.vpc_cidr
}

## Public 
resource "aws_subnet" "edu_subnet_public" {
  vpc_id            = aws_vpc.edu_hillel_vpc.id
  cidr_block        = var.vpc_cidr_public
  availability_zone = var.aws_region
  tags = {
    Name = "Public network"
  }
}


## Private 
resource "aws_subnet" "edu_subnet_private" {
  vpc_id            = aws_vpc.edu_hillel_vpc.id
  cidr_block        = var.vpc_cidr_private
  availability_zone = var.aws_region
  tags = {
    Name = "Private network"
  }
}

#Internet  GW
resource "aws_internet_gateway" "edu_GW" {
  vpc_id = aws_vpc.edu_hillel_vpc.id
}


#Elastic IP for GW
resource "aws_eip" "edu_elastic_IP" {
}

#NAT gateway
resource "aws_nat_gateway" "edu_nat_GW" {
  allocation_id = aws_eip.edu_elastic_IP.id
  subnet_id     = aws_subnet.edu_subnet_public.id
  #depends_on    = ["aws_internet_gateway.edu_GW"]
}
#Output 
output "GW_IP" {
  value = aws_eip.edu_elastic_IP.public_ip
}

#Default route to Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_vpc.edu_hillel_vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.edu_GW.id
}

#Routing table for private subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.edu_hillel_vpc.id
}

resource "aws_route" "private_route" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.edu_nat_GW.id
}

#Routing table for public subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.edu_hillel_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.edu_GW.id
  }
}

#Associate  public subnet to public route table
resource "aws_route_table_association" "public_subnet_association" {
  subnet_id      = aws_subnet.edu_subnet_public.id
  route_table_id = aws_vpc.edu_hillel_vpc.main_route_table_id
}

#Associate  private subnet to private route table
resource "aws_route_table_association" "private_subnet_association" {
  subnet_id      = aws_subnet.edu_subnet_private.id
  route_table_id = aws_route_table.private.id
  #route_table_id = aws_route_table.private_route_table.id
}

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
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.edu_subnet_private.id
}

resource "aws_instance" "public_instance" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"
  subnet_id     = aws_subnet.edu_subnet_public.id
}
