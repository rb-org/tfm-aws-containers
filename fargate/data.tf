# Data Resources

data "aws_caller_identity" "current" {}

data "template_file" "flaskapi_task_def" {
  template = "${file("${path.module}/task_defs/flaskapi.tpl")}"

  vars = {
    task_name      = "${local.task_name}"
    image_url      = "${var.flaskapi_repo_url}:latest"
    container_port = "${var.flaskapi_port}"
    host_port      = "${var.flaskapi_port}"
    essential      = true
    db_endpoint    = "${var.flaskapi_rds_instance_endpoint}"
    database       = "people"
    password       = "DifficultPassword!"
    port           = "3306"
    user           = "flask"

    # cpu            = "${var.cpu}"
    # memory         = "${var.memory}"
  }
}
