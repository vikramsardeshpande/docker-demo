resource "aws_security_group" "myapp-elb-securitygroup" {
  vpc_id = "${aws_vpc.default.id}"
  name = "myapp-elb"
  description = "security group for ecs docker image access"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 80
      to_port = 80
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  tags {
    Name = "myapp-elb"
  }
}
