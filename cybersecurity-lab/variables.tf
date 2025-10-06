variable "aws_region" {
  description = "AWS region to deploy the lab"
  type        = string
  default     = "us-east-1"
}

variable "availability_zone" {
  description = "Availability zone for the subnets"
  type        = string
  default     = "us-east-1a"
}

variable "vpc_cidr" {
  description = "CIDR block for the lab VPC"
  type        = string
  default     = "10.20.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
  default     = "10.20.10.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR block for the private subnet"
  type        = string
  default     = "10.20.20.0/24"
}

variable "ssh_key_name" {
  description = "Existing EC2 key pair for Linux hosts"
  type        = string
}

variable "windows_key_name" {
  description = "Existing EC2 key pair for Windows RDP access"
  type        = string
}

variable "attacker_ami" {
  description = "AMI ID for the attacker Ubuntu VM"
  type        = string
}

variable "attacker_instance_type" {
  description = "Instance type for the attacker VM"
  type        = string
  default     = "t3.small"
}

variable "dvwa_ami" {
  description = "AMI ID for the DVWA Metasploitable VM"
  type        = string
}

variable "dvwa_instance_type" {
  description = "Instance type for the DVWA host"
  type        = string
  default     = "t3.small"
}

variable "windows_ami" {
  description = "AMI ID for the Windows victim"
  type        = string
}

variable "windows_instance_type" {
  description = "Instance type for the Windows host"
  type        = string
  default     = "t3.large"
}

variable "siem_ami" {
  description = "AMI ID for the optional SIEM server"
  type        = string
  default     = ""
}

variable "siem_instance_type" {
  description = "Instance type for the SIEM server"
  type        = string
  default     = "t3.medium"
}

variable "enable_siem" {
  description = "Whether to deploy the SIEM host"
  type        = bool
  default     = true
}
