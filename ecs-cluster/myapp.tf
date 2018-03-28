# app

data "template_file" "myapp-task-definition-template" {
  template               = "${file("templates/app.json.tpl")}"
  vars {
    #REPOSITORY_URL = "${replace("${aws_ecr_repository.myapp.repository_url}", "https://", "")}"
    REPOSITORY_URL = "${replace("${data.terraform_remote_state.ecr.myapp-repository-URL}", "https://", "")}"
    APP_VERSION = "${var.MYAPP_VERSION}"
  }
}

resource "aws_ecs_task_definition" "myapp-task-definition" {
  family                = "myapp"
  container_definitions = "${data.template_file.myapp-task-definition-template.rendered}"
}

resource "aws_ecs_service" "myapp-service" {
  count = "${var.MYAPP_SERVICE_ENABLE}"
  name = "myapp"
  cluster = "${aws_ecs_cluster.example-cluster.id}"
  task_definition = "${aws_ecs_task_definition.myapp-task-definition.arn}"
  desired_count = 1
  iam_role = "${aws_iam_role.ecs-service-role.arn}"
  depends_on = ["aws_iam_policy_attachment.ecs-service-attach1"]

  load_balancer {
    elb_name = "${data.terraform_remote_state.vpc.elb_id}"
    container_name = "myapp"
    container_port = 8080
  }
  lifecycle { ignore_changes = ["task_definition"] }
}
