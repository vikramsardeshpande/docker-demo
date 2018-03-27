resource "aws_elb" "myapp-elb" {
  name = "myapp-elb"

  listener {
    instance_port = 8080
    instance_protocol = "http"
    lb_port = 80
    lb_protocol = "http"
  }

  health_check {
    healthy_threshold = 3
    unhealthy_threshold = 3
    timeout = 30
    target = "HTTP:8080/"
    interval = 60
  }

  cross_zone_load_balancing = true
  idle_timeout = 400
  connection_draining = true
  connection_draining_timeout = 400

  subnets = ["${aws_subnet.us-east-1b-public.id}","${aws_subnet.us-east-1d-public.id}"]
  security_groups = ["${aws_security_group.myapp-elb-securitygroup.id}"]

  tags {
    Name = "myapp-elb"
  }
}
