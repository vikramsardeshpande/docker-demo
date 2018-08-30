# S3 Remote State
#-------------------------------
terraform {
  backend "s3" {
    bucket = "poc-demo1-terraform-state"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

resource "aws_vpc" "poc-demo1-vpc" {
	cidr_block = "${var.vpc_cidr}"
  enable_dns_hostnames = true

  tags {
    Name = "VPC POC Demo-1 "
  }
}

resource "aws_internet_gateway" "poc-demo1-igw" {
	vpc_id = "${aws_vpc.poc-demo1-vpc.id}"

  tags {
    Name = "IGW POC Demo-1 "
  }
}

resource "aws_subnet" "poc-demo1-public-subnet" {
	vpc_id = "${aws_vpc.poc-demo1-vpc.id}"

	cidr_block = "${var.public_subnet_cidr}"
	availability_zone = "us-east-1b"

  tags {
    Name = "public subnet POC Demo-1 "
  }
}

resource "aws_subnet" "poc-demo1-private-subnet" {
	vpc_id = "${aws_vpc.poc-demo1-vpc.id}"

	cidr_block = "${var.private_subnet_cidr}"
	availability_zone = "us-east-1d"

  tags {
    Name = "private subnet POC Demo-1 "
    Tier = "private"
  }
}

resource "aws_subnet" "poc-demo1-private-subnet2" {
	vpc_id = "${aws_vpc.poc-demo1-vpc.id}"

	cidr_block = "${var.private_subnet2_cidr}"
	availability_zone = "us-east-1d"

  tags {
    Name = "private subnet 2 POC Demo-1 "
    Tier = "private"
  }
}

data "aws_subnet_ids" "poc-demo1-private-ids" {
  vpc_id = "${aws_vpc.poc-demo1-vpc.id}"
  tags {
    Tier = "private"
  }
}

resource "aws_route_table" "poc-demo1-public-route" {
	vpc_id = "${aws_vpc.poc-demo1-vpc.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_internet_gateway.poc-demo1-igw.id}"
	}

  tags {
    Name = "public route POC Demo-1 "
  }
}
# Routing table for public subnets
resource "aws_route_table_association" "poc-demo1-public-route-assoc" {
	subnet_id = "${aws_subnet.poc-demo1-public-subnet.id}"
	route_table_id = "${aws_route_table.poc-demo1-public-route.id}"
}

resource "aws_route_table_association" "poc-demo1-private-route-assoc" {
	subnet_id = "${element(data.aws_subnet_ids.poc-demo1-private-ids.ids)}"
	route_table_id = "${aws_route_table.poc-demo1-private-route.id}"
}

resource "aws_eip" "poc-demo1-natip" {
  vpc = true
  }

resource "aws_nat_gateway" "poc-demo1-natgw" {
  allocation_id = "${aws_eip.poc-demo1-natip.id}"
  subnet_id     = "${aws_subnet.poc-demo1-public-subnet.id}"

  tags {
    Name = "NAT GW POC Demo-1 "
  }

  depends_on = ["aws_internet_gateway.poc-demo1-igw"]
}

resource "aws_route_table" "poc-demo1-private-route" {
	vpc_id = "${aws_vpc.poc-demo1-vpc.id}"

	route {
		cidr_block = "0.0.0.0/0"
		gateway_id = "${aws_nat_gateway.poc-demo1-natgw.id}"
	}

  tags {
    Name = "private route POC Demo-1 "
  }
}

# output
output "vpcid" {
   value = "${aws_vpc.poc-demo1-vpc.id}"
}

output "private_subnet_id" {
   value = "${aws_subnet.poc-demo1-private-subnet.id}"
}

output "public_subnet_id" {
   value = "${aws_subnet.poc-demo1-public-subnet.id}"
}

output "private_subnet2_id" {
   value = "${aws_subnet.poc-demo1-private-subnet2.id}"
}

output "private_subnet_ids" {
   value = ["${element(data.aws_subnet_ids.poc-demo1-private-ids.ids)}"]
}
