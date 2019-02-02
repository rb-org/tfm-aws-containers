resource "aws_ecs_task_definition" "flaskapi" {
  family                = "service"
  container_definitions = "${data.template_file.flaskapi_task_def.rendered}"

  requires_compatibilities = ["FARGATE"]
  cpu                      = "${var.cpu}"
  memory                   = "${var.memory}"

  execution_role_arn = "${local.task_exec_role}"
  network_mode       = "awsvpc"
}
