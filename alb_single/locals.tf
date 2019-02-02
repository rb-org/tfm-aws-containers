locals {
  name_prefix     = "${terraform.workspace}"
  name_suffix     = "${var.name_suffix == "" ? "flaskapi-alb" : var.name_suffix}"
  lb_name         = "${local.name_prefix}-${local.name_suffix}"
  tg_name_fargate = "${local.lb_name}-fargate-tg"
  tg_name_ecs     = "${local.lb_name}-ecs-tg"
  tg_name_eks     = "${local.lb_name}-eks-tg"
  tg_name_ec2     = "${local.lb_name}-ec2-tg"

  log_location_prefix = "${var.log_location_prefix == "" ? local.lb_name : var.log_location_prefix}"

  https_listener_ssl_cert_names = "${concat(local.ssl_cert_primary_name,local.ssl_cert_sans)}"
  ssl_cert_primary_name         = ["${local.fargate_fqdn}"]

  ssl_cert_sans = [
    "${local.ecs_fqdn}",
    "${local.eks_fqdn}",
    "${local.ec2_fqdn}",
  ]

  fargate_fqdn = "flaskapi-fgt.${var.r53_dns_domain_pub}"
  ec2_fqdn     = "flaskapi-ec2.${var.r53_dns_domain_pub}"
  ecs_fqdn     = "flaskapi-ecs.${var.r53_dns_domain_pub}"
  eks_fqdn     = "flaskapi-eks.${var.r53_dns_domain_pub}"
  account_id   = "${data.aws_caller_identity.current.account_id}"
  local_region = "${data.aws_region.current.name}"

  # [sa-east-1, us-west-1, us-west-2, ap-northeast-1, ap-southeast-1, eu-west-1, us-east-1, ap-southeast-2]]
  r53_hc_regions                  = ["eu-west-1", "us-west-2", "us-east-1"]
  enable_r53_hcs                  = "${var.enable_route53_health_checks  || var.enable_route53_health_checks =="true" ? 1 : 0}"
  evaluate_target_health          = "${var.evaluate_target_health  || var.evaluate_target_health =="true" ? 1 : 0}"
  enable_cloudwatch_alarm_actions = "${var.enable_cloudwatch_alarm_actions  || var.enable_cloudwatch_alarm_actions =="true" ? true : false}"

  sns_topic_arn_prefix    = "arn:aws:sns:${local.local_region}:${local.account_id}:${local.name_prefix}"
  sns_topic_arn_prefix_cw = "arn:aws:sns:us-east-1:${local.account_id}:${local.name_prefix}"
  sns_ok_arn              = "${local.sns_topic_arn_prefix}-ok"
  sns_default_arn         = "${local.sns_topic_arn_prefix}-default"
  sns_urgent_arn          = "${local.sns_topic_arn_prefix}-urgent"
  sns_emergency_arn       = "${local.sns_topic_arn_prefix}-emergency"
  sns_ok_arn_cw           = "${local.sns_topic_arn_prefix_cw}-ok"
  sns_default_arn_cw      = "${local.sns_topic_arn_prefix_cw}-default"
  sns_urgent_arn_cw       = "${local.sns_topic_arn_prefix_cw}-urgent"
  sns_emergency_arn_cw    = "${local.sns_topic_arn_prefix_cw}-emergency"
}
