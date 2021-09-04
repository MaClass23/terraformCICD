
variable "region" {
    description = "AWS region"
    type = string
    default = "us-east-1"
}

variable "vpc_cidr" {
    description = "CIDR block for the VPC"
    type = string
    default = "10.0.0.0/16"
}

variable "ami1_id" {
    description = "ID of the AMI1 used"
    type = string
    default =  "ami-0747bdcabd34c712a"
}
/*
variable "ami2_id" {
    description = "ID of the AMI2 used"
    type = string
    default = "ami-0b0af3577fe5e3532"
}*/
variable "instance_type1" {
    description = "Type of the instance1"
    type = string
    default = "t2.micro"
}
/*
variable "instance_type2" {
    description = "Type of the instance2"
    type = string
    default = "t2.medium"
}*/

variable "key_name" {
    description = "SSH Key pair used to connect"
    type = string
    default = "testkey"
}

variable "my_ip" {
  type        = string
  default     = "70.55.109.151/32"
  description = "my ip address"
}

variable "jenkins_ip" {
  type        = string
  default     = "34.202.231.73/32"
  description = "jenkins ip address"
}
