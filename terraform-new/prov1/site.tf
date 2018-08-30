provider "aws" {
#  access_key = "${var.aws_access_key}"
#  secret_key = "${var.aws_secret_key}"
  region = "${var.AWS_REGION}"
}

module "network" {
  source = "./modules/network"
  vpc_cidr = "10.0.0.0/16"
  public_subnet_cidr = "10.0.1.0/24"
  private_subnet_cidr = "10.0.2.0/24"
  private_subnet2_cidr = "10.0.3.0/24"
}

resource "aws_db_instance" "poc-demo1" {
  # (resource arguments)
}

