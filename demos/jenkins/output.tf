output "jenkins" {
  value = "${aws_instance.jenkins-instance.public_ip}"
}
