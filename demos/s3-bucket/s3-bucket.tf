resource "aws_s3_bucket" "webdeploy-terraform-state" {
bucket = "webdeploy-terraform-state"
acl = "private"
versioning {
enabled = true
}

lifecycle {
prevent_destroy = true
}
}

output "s3_bukcet_arn" {
value = "${aws_s3_bucket.webdeploy-terraform-state.arn}"
}
