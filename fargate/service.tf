resource "aws_ecs_service" "flaskapi" {
  name            = "mongodb"
  cluster         = "${aws_ecs_cluster.main.id}"
  task_definition = "${aws_ecs_task_definition.flaskapi.arn}"
  desired_count   = "${var.desired_count}"

  load_balancer {
    target_group_arn = "${var.alb_single_tg_arns[0]}"
    container_name   = "${local.container_name}"
    container_port   = "${var.flaskapi_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }
}