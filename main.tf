module "alb_single" {
  source = "./alb_single"

  # Network
  vpc_id         = "${data.terraform_remote_state.flaskapi_base.vpc_id}"
  public_subnets = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"

  # DNS
  r53_dns_domain_pub = "${var.r53_dns_domain_pub}"
  zone_id_pub        = "${data.aws_route53_zone.zone_pub.id}"

  # ALB
  target_group_backend_protocol   = "${var.flaskapi_protocol}"
  target_group_backend_port       = "${var.flaskapi_port}"
  enable_route53_health_checks    = true
  enable_cloudwatch_alarm_actions = true
  https_listeners_count           = 1
  wildcard_cert_arn               = "${data.terraform_remote_state.flaskapi_base.wildcard_cert_arn}"

  # Security Groups
  sg_r53_id = "${data.terraform_remote_state.flaskapi_base.r53_hcs_sg_id}"
  sg_alb_id = "${data.terraform_remote_state.flaskapi_base.alb_sg_id}"

  # Tags
  default_tags = "${var.default_tags}"

  # Monitoring
  log_bucket_name        = "${data.terraform_remote_state.flaskapi_base.s3_lb_logs_id}"
  alb_logging_enabled    = "${var.alb_logging_enabled}"
  evaluate_target_health = "${var.evaluate_target_health}"
}

module "fargate" {
  source = "./fargate"

  #ALB
  alb_single_tg_arns = "${module.alb_single.tg_arns}"

  # Tags
  default_tags = "${var.default_tags}"

  # Image
  flaskapi_repo_url = "${data.terraform_remote_state.ecr.flaskapi_repository_url}"

  # Database
  flaskapi_rds_instance_endpoint = "${data.terraform_remote_state.database.flaskapi_rds_instance_endpoint}"

  # Network
  public_subnets = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"
  flaskapi_sg_id = "${data.terraform_remote_state.flaskapi_base.flaskapi_sg_id}"
}
