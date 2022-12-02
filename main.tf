provider "aws" {
  region = "ap-south-1"
  access_key = ""
  secret_key = ""

}

#1.vpc
resource "aws_vpc" "prod-vpc" {
  cidr_block = "10.0.0.0/16"
  tags = {
    Name= "production"
  }
}
 


 #2.gateway
resource "aws_internet_gateway" "gw" {
    vpc_id=aws_vpc.prod-vpc

    tags{
        Name ="main"
    }  
}


#3.routing table
resource "aws_route_table" "example" {
  vpc_id = aws_vpc.example.id

  route {
    cidr_block = "0.0.0.0/0"      
    gateway_id = aws_internet_gateway.gw
  }

  route {
    ipv6_cidr_block        = "::/0"
    egress_only_gateway_id = aws_egress_only_internet_gateway.example.id
  }

  tags = {
    Name = "prod"
  }
}

#4.subnet
resource "aws_subnet" "prod-subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "ap-south-1"

  tags = {
    Name = "prod-subnet"
  }
}


#5.association subnet 
resource "aws_route_table_association" "a" {
  subnet_id      = aws_subnet.prod-subnet
  route_table_id = aws_route_table.example
}


#6. security group
resource "aws_security_group" "allow_web" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.prod-vpc

  ingress {
    description      = "web from ssh"
    from_port        = 22
    to_port          = 22
    protocol         = "ssh"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
  ingress {
    description      = "TLS from https"
    from_port        = 443
    to_port          = 443
    protocol         = "https"
    cidr_blocks      = "0.0.0.0/0"//[aws_vpc.prod.cidr_block]
    ipv6_cidr_blocks = ["::/0"]//[aws_vpc.prod.ipv6_cidr_block]
  }
  ingress {
    description      = "TLS from http"
    from_port        = 80
    to_port          = 80
    protocol         = "http"
    cidr_blocks      = "0.0.0.0/0"
    ipv6_cidr_blocks = ["::/0"]
  }


  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1" //means that can access any protocol
    cidr_blocks      = ["0.0.0.0/0"] //any
    ipv6_cidr_blocks = ["::/0"] //any
  }

  tags = {
    Name = "allow_web"
  }
}

#7.
resource "aws_network_interface" "test" {
  subnet_id       = aws_subnet.prod-subnet
  private_ips     = ["10.0.0.50"]
  security_groups = [aws_security_group.web]

  attachment {
    instance     = aws_instance.test.id
    device_index = 1
  }
}


#8.elastic ip
resource "aws_eip" "one" {
  vpc                       = true
  network_interface         = aws_network_interface.test
  associate_with_private_ip = "10.0.1.50"
  depends_on = [aws_internet_gateway.gw]
}

