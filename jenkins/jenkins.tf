provider "aws" {
#       access_key = "${var.aws_access_key}"
#       secret_key = "${var.aws_secret_key}"
        region = "${var.AWS_REGION}"
}
data "terraform_remote_state" "vpc" {
  backend = "s3"
  config {
    region = "us-east-1"
    bucket = "webdeploy-terraform-state"
    key    = "terraform.tfstate"
  }
}


resource "aws_instance" "jenkins-instance" {
  ami           = "${lookup(var.AMIS, var.AWS_REGION)}"
  instance_type = "t2.small"

  # the VPC subnet
  subnet_id = "${data.terraform_remote_state.vpc.public_subnet_id_1b}"

  # the security group
  vpc_security_group_ids = ["${aws_security_group.jenkins-securitygroup.id}"]

  # the public SSH key
  key_name = "mykey"

  # user data
  user_data = "${data.template_cloudinit_config.cloudinit-jenkins.rendered}"
  associate_public_ip_address = true

}

#resource "aws_ebs_volume" "jenkins-data" {
#    availability_zone = "eu-west-1a"
#    size = 20
#    type = "gp2" 
#    tags {
#        Name = "jenkins-data"
#    }
#}
#
#resource "aws_volume_attachment" "jenkins-data-attachment" {
#  device_name = "${var.INSTANCE_DEVICE_NAME}"
#  volume_id = "${aws_ebs_volume.jenkins-data.id}"
#  instance_id = "${aws_instance.jenkins-instance.id}"
##}

