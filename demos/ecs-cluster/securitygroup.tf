resource "aws_security_group" "ecs-securitygroup" {
  vpc_id = "${data.terraform_remote_state.vpc.vpc_id}"
  name = "ecs"
  description = "security group for ecs"
  egress {
      from_port = 0
      to_port = 0
      protocol = "-1"
      cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
      from_port = 8080
      to_port = 8080
      protocol = "tcp"
      #security_groups = ["${aws_security_group.myapp-elb-securitygroup.id}"]
      security_groups = ["${data.terraform_remote_state.vpc.myapp-elb-securitygroup}"]
  } 
  ingress {
      from_port = 22
      to_port = 22
      protocol = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
  } 
  tags {
    Name = "ecs"
  }
}
