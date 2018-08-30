resource "aws_ecr_repository" "myapp" {
  name = "myapp"
}
# S3 Remote State
#-------------------------------
terraform {
  backend "s3" {
    bucket = "webdeploy-terraform-state"
    key    = "ecr-terraform.tfstate"
    region = "us-east-1"
  }
}

