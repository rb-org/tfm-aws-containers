module "alb_single" {
  source = "./alb_single"

  # Network
  vpc_id         = "${data.terraform_remote_state.flaskapi_base.vpc_id}"
  public_subnets = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"

  # DNS
  r53_dns_domain_pub = "${var.r53_dns_domain_pub}"
  zone_id_pub        = "${data.aws_route53_zone.zone_pub.id}"

  # ALB
  target_group_backend_protocol   = "HTTP"
  target_group_backend_port       = "5000"
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

# module "ec2_xld" {
#   source = "./ec2_xld"


#   region   = "${var.region}"
#   key_name = "${var.key_name}"
#   workload = "${var.workload}"


#   # Network
#   private_subnets = "${data.terraform_remote_state.mgmt_base.private_subnets}"
#   vpc_cidr_exol   = ["${var.exol_wkspc_cidrs}"]
#   vpc_id          = "${data.terraform_remote_state.mgmt_base.vpc_id}"
#   public_subnets  = "${data.terraform_remote_state.mgmt_base.public_subnets}"


#   # Security Groups
#   sg_win_id     = "${data.terraform_remote_state.mgmt_base.sg_win_id}"
#   sg_tux_id     = "${data.terraform_remote_state.mgmt_base.sg_tux_id}"
#   sg_r53_id     = "${data.terraform_remote_state.mgmt_base.sg_r53_id}"
#   sg_xld_id     = "${data.terraform_remote_state.mgmt_base.sg_xld_id}"
#   sg_xld_alb_id = "${data.terraform_remote_state.mgmt_base.sg_xld_alb_id}"
#   allowed_ips   = "${var.allowed_ips}"


#   # Tags and variables
#   app_id       = "xld"
#   app_role     = "xldeploy"
#   default_tags = "${var.default_tags}"
#   cc           = "${var.cc}"


#   # Patching
#   windows_patch_day_0 = "${var.windows_patch_day_0}"
#   windows_patch_day_1 = "${var.windows_patch_day_1}"


#   # Monitoring
#   enable_monitoring        = "${var.enable_monitoring}"
#   enable_cw_metrics        = "${var.enable_cw_metrics}"
#   enable_cw_alarm_disk_win = "${var.enable_cw_alarm_disk_win}"
#   enable_cw_alarm_cpu      = "${var.enable_cw_alarm_cpu}"
#   log_bucket_name          = "${data.terraform_remote_state.mgmt_base.s3_lb_logs_id}"
#   log_group_retention      = "${var.log_group_retention}"
#   alb_logging_enabled      = "${var.alb_logging_enabled}"
#   evaluate_target_health   = "${var.evaluate_target_health}"


#   # Route53
#   zone_id_pub        = "${data.aws_route53_zone.zone_pub.id}"
#   r53_dns_domain_pub = "${var.r53_dns_domain_pub}"


#   # ALB
#   enable_route53_health_checks    = "${var.enable_route53_health_checks}"
#   enable_cloudwatch_alarm_actions = "${var.enable_cloudwatch_alarm_actions}"
#   sg_r53_id                       = "${data.terraform_remote_state.mgmt_base.sg_r53_id}"
#   sg_exact_offices_id             = "${data.terraform_remote_state.mgmt_base.sg_exact_offices_id}"
#   allowed_ips                     = "${var.allowed_ips}"
# }

