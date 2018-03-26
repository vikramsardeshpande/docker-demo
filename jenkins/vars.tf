variable "AWS_REGION" {
  default = "us-east-1"
}
variable "PATH_TO_PRIVATE_KEY" {
  default = "mykey"
}
variable "PATH_TO_PUBLIC_KEY" {
  default = "mykey.pub"
}
variable "INSTANCE_DEVICE_NAME" {
  default = "/dev/xvdh"
}
variable "JENKINS_VERSION" {
  default = "2.89.4"
}
# Ubuntu Server 16.04 LTS (HVM), SSD Volume Type - ami-66506c1c
variable "AMIS" {
  type = "map"
  default = {
    us-east-1 = "ami-66506c1c"
    us-west-2 = "6"
    eu-west-1 = "7"
  }
}
