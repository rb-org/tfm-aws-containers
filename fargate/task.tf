resource "aws_ecs_task_definition" "flaskapi" {
  count                 = "${local.local_count}"
  family                = "${local.task_name}"
  container_definitions = "${data.template_file.flaskapi_task_def.rendered}"

  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"

  execution_role_arn = "${local.task_exec_role}"

  # task_role_arn      = "${var.ecs_role_arn}"
  network_mode = "awsvpc"

  # Tags
  tags = "${merge(
    var.default_tags, 
    map(
      "Name", "${local.task_name}",
      "Workspace", "${terraform.workspace}"
    )
  )}"
}
