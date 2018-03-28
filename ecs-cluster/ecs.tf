data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    region = "us-east-1"
    bucket = "webdeploy-terraform-state"
    key    = "terraform.tfstate"
  }
}
data "terraform_remote_state" "ecr" {
  backend = "s3"
  config {
    region = "us-east-1"
    bucket = "webdeploy-terraform-state"
    key    = "ecr-terraform.tfstate"
  }
}

# cluster
resource "aws_ecs_cluster" "example-cluster" {
    name = "example-cluster"
}
resource "aws_launch_configuration" "ecs-example-launchconfig" {
  name_prefix          = "ecs-launchconfig"
  image_id             = "${lookup(var.ECS_AMIS, var.AWS_REGION)}"
  instance_type        = "${var.ECS_INSTANCE_TYPE}"
  #key_name             = "${aws_key_pair.mykeypair.key_name}"
  key_name             = "mykey"
  iam_instance_profile = "${aws_iam_instance_profile.ecs-ec2-role.id}"
  security_groups      = ["${aws_security_group.ecs-securitygroup.id}"]
  user_data            = "#!/bin/bash\necho 'ECS_CLUSTER=example-cluster' > /etc/ecs/ecs.config\nstart ecs"
  lifecycle              { create_before_destroy = true }
  associate_public_ip_address = true
}
resource "aws_autoscaling_group" "ecs-example-autoscaling" {
  name                 = "ecs-example-autoscaling"
  #vpc_zone_identifier  = ["${aws_subnet.main-public-1.id}", "${aws_subnet.main-public-2.id}"]
  vpc_zone_identifier  = ["${data.terraform_remote_state.vpc.public_subnet_id_1b}", "${data.terraform_remote_state.vpc.public_subnet_id_1d}"]
  launch_configuration = "${aws_launch_configuration.ecs-example-launchconfig.name}"
  min_size             = 1
  max_size             = 1
  tag {
      key = "Name"
      value = "ecs-ec2-container"
      propagate_at_launch = true
  }
}
