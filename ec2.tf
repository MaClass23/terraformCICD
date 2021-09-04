#Create provider
provider "aws" {
       region = var.region
   }
#Create VPC
   resource "aws_vpc" "MaVpc1" {
     cidr_block = var.vpc_cidr

     tags = {
       Name = "MaVpc1"
     }
   }

   #Create internet gateway
resource "aws_internet_gateway" "IGW" {
  vpc_id = aws_vpc.MaVpc1.id

  tags = {
    Name = "IGW"
  }
}

#create route table
resource "aws_route_table" "MaRT" {
  vpc_id = aws_vpc.MaVpc1.id

  route {
      cidr_block = "0.0.0.0/0"
      gateway_id = aws_internet_gateway.IGW.id
    }

  tags = {
    Name = "MaRT"
  }
}

#Create multiple subnets
resource "aws_subnet" "Public-subnet" {
  vpc_id     = aws_vpc.MaVpc1.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Public-subnet"
  }
}

resource "aws_subnet" "Private-subnet" {
  vpc_id     = aws_vpc.MaVpc1.id
  cidr_block = "10.0.2.0/24"
  availability_zone = "us-east-1c"

  tags = {
    Name = "Private-subnet"
  }
}

#Create route table association
resource "aws_route_table_association" "MaRTA" {
  subnet_id      = aws_subnet.Public-subnet.id
  route_table_id = aws_route_table.MaRT.id
}

#Create Security group
resource "aws_security_group" "SG1" {
  name        = "allow_All"
  description = "Allow all inbound traffic"
  vpc_id      = aws_vpc.MaVpc1.id

  ingress {
      description      = "SSH"
      from_port        = 22
      to_port          = 22
      protocol         = "tcp"
      cidr_blocks      = [var.my_ip, var.jenkins_ip]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

  ingress {
      description      = "HTTPS"
      from_port        = 443
      to_port          = 443
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

ingress {
      description      = "HTTP"
      from_port        = 80
      to_port          = 80
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }

  egress {
      from_port        = 0
      to_port          = 0
      protocol         = "-1"
      cidr_blocks      = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = ["::/0"]
    }

  tags = {
    Name = "SG1"
  }
}

resource "aws_nat_gateway" "NatGW" {
  connectivity_type = "private"
  subnet_id         = aws_subnet.Public-subnet.id
}

/*
#Create eip
resource "aws_eip" "eip1" {
  instance = aws_instance.ubuntu[count.index].id
  count = 3
  vpc      = true
   depends_on  = [aws_internet_gateway.IGW]
}
*/

#create network interface
resource "aws_network_interface" "NWI2" {
  subnet_id       = aws_subnet.Public-subnet.id
  security_groups = [aws_security_group.SG1.id]
}

#Create webservers
resource "aws_instance" "ubuntu" {

  ami           = var.ami1_id
  instance_type = var.instance_type1
  #count = 3
  key_name = var.key_name
  subnet_id = aws_subnet.Public-subnet.id
  security_groups = [aws_security_group.SG1.id]
  associate_public_ip_address = true

  user_data = file("entry-script.sh")

  tags = {
    Name = "webserver"
   # Name = "webserver-${count.index}"
  }
}
/*
#Create appservers
resource "aws_instance" "RedHat" {

  ami           = var.ami2_id
  instance_type = var.instance_type2
  count = 3
  key_name = var.key_name
  subnet_id = aws_subnet.Private-subnet.id
  security_groups = [aws_security_group.SG1.id]

  tags = {
    Name = "appserver-${count.index}"
  }
}
*/