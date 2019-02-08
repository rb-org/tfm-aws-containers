resource "aws_ecs_service" "flaskapi" {
  count           = "${local.local_count}"
  name            = "${local.service_name}"
  cluster         = "${var.cluster_id}"
  task_definition = "${aws_ecs_task_definition.flaskapi.arn}"
  desired_count   = "${var.desired_count}"
  launch_type     = "EC2"

  health_check_grace_period_seconds = 60

  load_balancer {
    target_group_arn = "${var.alb_single_tg_arns[1]}"
    container_name   = "${local.container_name}"
    container_port   = "${var.flaskapi_port}"
  }

  lifecycle {
    ignore_changes = ["desired_count"]
  }

  network_configuration {
    subnets = ["${var.private_subnets}"]

    security_groups = [
      "${var.flaskapi_sg_id}",
      "${var.db_clients_sg_id}",
    ]
  }

  deployment_controller {
    type = "ECS"
  }
}
