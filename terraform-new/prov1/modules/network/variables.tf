variable "vpc_cidr" {
  default = "10.0.0.0/16"
  description = "VPC cidr_block"
}

variable "public_subnet_cidr" {
  default = "10.0.1.0/24"
  description = "public Subnet cidr_block"
}

variable "private_subnet_cidr" {
  default = "10.0.2.0/24"
  description = "private subnet cidr_block"
}

variable "private_subnet2_cidr" {
  default = "10.0.3.0/24"
  description = "private subnet 2 cidr_block"
}
