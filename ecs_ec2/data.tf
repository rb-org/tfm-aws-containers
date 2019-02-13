# Data Resources

data "aws_caller_identity" "current" {}

data "template_file" "flaskapi_task_def" {
  template = "${file("${path.module}/task_defs/flaskapi.tpl")}"

  vars = {
    task_name       = "${local.task_name}"
    image_url       = "${data.aws_ecr_repository.flaskapi.repository_url}:${var.image_version}"
    container_port  = "${var.flaskapi_port}"
    host_port       = "${var.flaskapi_port}"
    essential       = true
    db_endpoint     = "${var.flaskapi_rds_instance_endpoint}"
    database        = "people"
    password        = "DifficultPassw0rd!"
    user            = "flask"
    log_group       = "${var.log_group_name}"
    region          = "${data.aws_region.current.name}"
    log_stream_name = "ecs-ec2"

    # port            = "3306"
    # cpu            = "${var.cpu}"
    # memory         = "${var.memory}"
  }
}

data "aws_region" "current" {}

data "aws_ecr_repository" "flaskapi" {
  name = "flaskapi"
}
