module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "3.4.0"

  # Required
  load_balancer_name = "${local.lb_name}"
  security_groups    = ["${var.sg_alb_id}"]
  subnets            = ["${var.public_subnets}"]
  vpc_id             = "${var.vpc_id}"

  # Optional
  enable_deletion_protection = "${var.enable_deletion_protection}"
  enable_http2               = "${var.enable_http2}"

  https_listeners_count = "${var.https_listeners_count}"

  https_listeners = "${list(
    map("certificate_arn", module.cert.arn, "port", var.https_listeners_ports[0], "target_group_index", 0)
    )}"

  extra_ssl_certs_count = 0

  extra_ssl_certs = "${list(
    map("certificate_arn", "", "https_listener_index", 0)
    )}"

  idle_timeout                 = "${var.idle_timeout}"
  ip_address_type              = "${var.ip_address_type}"
  listener_ssl_policy_default  = "${var.listener_ssl_policy_default}"
  load_balancer_create_timeout = "${var.load_balancer_create_timeout}"
  load_balancer_delete_timeout = "${var.load_balancer_delete_timeout}"
  load_balancer_is_internal    = "${var.load_balancer_is_internal}"
  load_balancer_update_timeout = "${var.load_balancer_update_timeout}"

  # Logging
  log_bucket_name     = "${var.log_bucket_name}"
  log_location_prefix = "${local.log_location_prefix}"
  logging_enabled     = "${var.alb_logging_enabled}"

  # Tags
  tags = "${merge(
    var.default_tags, 
    map(
      "Name", "${local.lb_name}",
      "Workspace", "${terraform.workspace}"
    )
  )}"

  # Target Groups
  target_groups_count = 4

  target_groups = "${list(
    map("name", "${local.tg_name_fargate}", "backend_protocol", "${var.target_group_backend_protocol}", "backend_port", "${var.target_group_backend_port}"),
    map("name", "${local.tg_name_ecs}", "backend_protocol", "${var.target_group_backend_protocol}", "backend_port", "${var.target_group_backend_port}"),
    map("name", "${local.tg_name_eks}", "backend_protocol", "${var.target_group_backend_protocol}", "backend_port", "${var.target_group_backend_port}"),
    map("name", "${local.tg_name_ec2}", "backend_protocol", "${var.target_group_backend_protocol}", "backend_port", "${var.target_group_backend_port}"),
    )}"

  target_groups_defaults = {
    "cookie_duration"                  = 3600
    "deregistration_delay"             = "${var.deregistration_delay}"
    "health_check_healthy_threshold"   = 5
    "health_check_interval"            = "${var.health_check_interval}"
    "health_check_matcher"             = "200"
    "health_check_path"                = "/"
    "health_check_port"                = "${var.health_check_port}"
    "health_check_timeout"             = 5
    "health_check_unhealthy_threshold" = 2
    "stickiness_enabled"               = false
    "target_type"                      = "${var.target_type}"
  }
}

resource "aws_alb_listener_rule" "listener_rule_fargate" {
  count        = "${var.https_listeners_count}"
  listener_arn = "${module.alb.https_listener_arns[count.index]}"
  priority     = 98

  action {
    type             = "forward"
    target_group_arn = "${module.alb.target_group_arns[0]}"
  }

  condition {
    field  = "host-header"
    values = ["flaskapi-fgt.*"]
  }
}

resource "aws_alb_listener_rule" "listener_rule_ecs" {
  count        = "${var.https_listeners_count}"
  listener_arn = "${module.alb.https_listener_arns[count.index]}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${module.alb.target_group_arns[1]}"
  }

  condition {
    field  = "host-header"
    values = ["flaskapi-ecs.*"]
  }
}

resource "aws_alb_listener_rule" "listener_rule_eks" {
  count        = "${var.https_listeners_count}"
  listener_arn = "${module.alb.https_listener_arns[count.index]}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${module.alb.target_group_arns[2]}"
  }

  condition {
    field  = "host-header"
    values = ["flaskapi-eks.*"]
  }
}

resource "aws_alb_listener_rule" "listener_rule_ec2" {
  count        = "${var.https_listeners_count}"
  listener_arn = "${module.alb.https_listener_arns[count.index]}"
  priority     = 99

  action {
    type             = "forward"
    target_group_arn = "${module.alb.target_group_arns[3]}"
  }

  condition {
    field  = "host-header"
    values = ["flaskapi-ec2.*"]
  }
}

# resource "aws_alb_target_group_attachment" "alb_tg_attachment_xld" {
#   count            = "${var.instance_count}"
#   target_group_arn = "${module.alb.target_group_arns[0]}"
#   target_id        = "${var.instance_ids_xld[count.index]}"
#   port             = 4516
# }


# resource "aws_alb_target_group_attachment" "alb_tg_attachment_xlr" {
#   count            = "${var.instance_count}"
#   target_group_arn = "${module.alb.target_group_arns[1]}"
#   target_id        = "${var.instance_ids_xld[count.index]}"
#   port             = 5516
# }

