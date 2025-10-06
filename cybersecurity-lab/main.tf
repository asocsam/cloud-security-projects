terraform {
  required_version = ">= 1.3.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

resource "aws_vpc" "lab" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "cyber-lab"
  }
}

resource "aws_internet_gateway" "lab" {
  vpc_id = aws_vpc.lab.id

  tags = {
    Name = "cyber-lab-igw"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = var.public_subnet_cidr
  map_public_ip_on_launch = true
  availability_zone = var.availability_zone

  tags = {
    Name = "cyber-lab-public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.lab.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone

  tags = {
    Name = "cyber-lab-private"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.lab.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.lab.id
  }

  tags = {
    Name = "cyber-lab-public-rt"
  }
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "attacker" {
  name        = "attacker-sg"
  description = "Allow SSH from the internet and egress to private subnet"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description = "SSH from anywhere"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "attacker-sg"
  }
}

resource "aws_security_group" "dvwa" {
  name        = "dvwa-sg"
  description = "Allow HTTP and custom ports from attacker"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description      = "HTTP"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    security_groups  = [aws_security_group.attacker.id]
  }

  ingress {
    description      = "DVWA custom web port"
    from_port        = 8888
    to_port          = 8888
    protocol         = "tcp"
    security_groups  = [aws_security_group.attacker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "dvwa-sg"
  }
}

resource "aws_security_group" "windows" {
  name        = "windows-victim-sg"
  description = "Allow RDP and syslog from attacker"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description     = "RDP"
    from_port       = 3389
    to_port         = 3389
    protocol        = "tcp"
    security_groups = [aws_security_group.attacker.id]
  }

  ingress {
    description     = "Sysmon/forwarder"
    from_port       = 9997
    to_port         = 9997
    protocol        = "tcp"
    security_groups = [aws_security_group.attacker.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "windows-victim-sg"
  }
}

resource "aws_security_group" "siem" {
  name        = "siem-sg"
  description = "Allow ingestion from Windows victim"
  vpc_id      = aws_vpc.lab.id

  ingress {
    description     = "SIEM forward"
    from_port       = 9997
    to_port         = 9997
    protocol        = "tcp"
    security_groups = [aws_security_group.windows.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "siem-sg"
  }
}

resource "aws_instance" "attacker" {
  ami           = var.attacker_ami
  instance_type = var.attacker_instance_type
  subnet_id     = aws_subnet.public.id
  key_name      = var.ssh_key_name
  vpc_security_group_ids = [aws_security_group.attacker.id]

  tags = {
    Name = "Attacker-VM"
    Role = "attacker"
  }
}

resource "aws_instance" "dvwa" {
  ami                         = var.dvwa_ami
  instance_type               = var.dvwa_instance_type
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.dvwa.id]

  tags = {
    Name = "DVWA-VM"
    Role = "dvwa"
  }
}

resource "aws_instance" "windows" {
  ami                         = var.windows_ami
  instance_type               = var.windows_instance_type
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false
  key_name                    = var.windows_key_name
  vpc_security_group_ids      = [aws_security_group.windows.id]

  tags = {
    Name = "Windows-Victim"
    Role = "victim"
  }
}

resource "aws_instance" "siem" {
  count                       = var.enable_siem ? 1 : 0
  ami                         = var.siem_ami
  instance_type               = var.siem_instance_type
  subnet_id                   = aws_subnet.private.id
  associate_public_ip_address = false
  key_name                    = var.ssh_key_name
  vpc_security_group_ids      = [aws_security_group.siem.id]

  tags = {
    Name = "SIEM-VM"
    Role = "siem"
  }
}
