# S3 Remote State
#-------------------------------
terraform {
  backend "s3" {
    bucket = "webdeploy-terraform-state"
    key    = "ecs-terraform.tfstate"
    region = "us-east-1"
  }
}

