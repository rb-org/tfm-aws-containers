provider "aws" {
  alias  = "cloudwatch"
  region = "us-east-1"
}

resource "aws_cloudwatch_metric_alarm" "lb_unhealthy_hosts" {
  count = "${local.evaluate_target_health}"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn}",
  ]

  alarm_description   = "Unhealthy Host count is above threshold, creating ticket."
  alarm_name          = "${local.lb_name} - FlaskAPI - ALB Unhealthy Host Count"
  comparison_operator = "GreaterThanThreshold"

  dimensions = {
    LoadBalancer = "${module.alb.load_balancer_arn_suffix}"
    TargetGroup  = "${module.alb.target_group_arn_suffixes[count.index]}"
  }

  evaluation_periods = "${var.lb_unhealthy_hosts_alarm_evaluation_periods}"
  metric_name        = "UnHealthyHostCount"
  namespace          = "AWS/ApplicationELB"

  ok_actions = [
    "${local.sns_ok_arn}",
  ]

  period    = "${var.lb_unhealthy_hosts_alarm_period}"
  statistic = "Average"
  threshold = "${var.lb_unhealthy_hosts_alarm_threshold}"
  unit      = "Count"
}

resource "aws_route53_health_check" "lb_r53_healthcheck_fargate" {
  count             = "${local.enable_r53_hcs}"
  fqdn              = "${local.fargate_fqdn}"
  type              = "${var.r53_healhcheck_type}"              # can be HTTP, HTTPS, TCP. Use HTTP_STR_MATCH or HTTPS_STR_MATCH when combined with search_string
  port              = "${var.r53_healhcheck_port}"
  resource_path     = "${var.r53_healhcheck_resource_path}"
  failure_threshold = "${var.r53_healhcheck_failure_threshold}"
  request_interval  = "${var.r53_healhcheck_request_interval}"
  regions           = "${local.r53_hc_regions}"

  search_string = "${var.r53_healhcheck_stringmatch}"

  tags {
    Name = "${local.lb_name}-${var.https_listeners_ports[count.index]}-fargate-healthcheck"
  }
}

resource "aws_route53_health_check" "lb_r53_healthcheck_ecs" {
  count             = "${local.enable_r53_hcs}"
  fqdn              = "${local.ecs_fqdn}"
  type              = "${var.r53_healhcheck_type}"              # can be HTTP, HTTPS, TCP. Use HTTP_STR_MATCH or HTTPS_STR_MATCH when combined with search_string
  port              = "${var.r53_healhcheck_port}"
  resource_path     = "${var.r53_healhcheck_resource_path}"
  failure_threshold = "${var.r53_healhcheck_failure_threshold}"
  request_interval  = "${var.r53_healhcheck_request_interval}"
  regions           = "${local.r53_hc_regions}"

  search_string = "${var.r53_healhcheck_stringmatch}"

  tags {
    Name = "${local.lb_name}-${var.https_listeners_ports[count.index]}-ecs-healthcheck"
  }
}

resource "aws_route53_health_check" "lb_r53_healthcheck_eks" {
  count             = "${local.enable_r53_hcs}"
  fqdn              = "${local.eks_fqdn}"
  type              = "${var.r53_healhcheck_type}"              # can be HTTP, HTTPS, TCP. Use HTTP_STR_MATCH or HTTPS_STR_MATCH when combined with search_string
  port              = "${var.r53_healhcheck_port}"
  resource_path     = "${var.r53_healhcheck_resource_path}"
  failure_threshold = "${var.r53_healhcheck_failure_threshold}"
  request_interval  = "${var.r53_healhcheck_request_interval}"
  regions           = "${local.r53_hc_regions}"

  search_string = "${var.r53_healhcheck_stringmatch}"

  tags {
    Name = "${local.lb_name}-${var.https_listeners_ports[count.index]}-eks-healthcheck"
  }
}

resource "aws_route53_health_check" "lb_r53_healthcheck_ec2" {
  count             = "${local.enable_r53_hcs}"
  fqdn              = "${local.ec2_fqdn}"
  type              = "${var.r53_healhcheck_type}"              # can be HTTP, HTTPS, TCP. Use HTTP_STR_MATCH or HTTPS_STR_MATCH when combined with search_string
  port              = "${var.r53_healhcheck_port}"
  resource_path     = "${var.r53_healhcheck_resource_path}"
  failure_threshold = "${var.r53_healhcheck_failure_threshold}"
  request_interval  = "${var.r53_healhcheck_request_interval}"
  regions           = "${local.r53_hc_regions}"

  search_string = "${var.r53_healhcheck_stringmatch}"

  tags {
    Name = "${local.lb_name}-${var.https_listeners_ports[count.index]}-ec2-healthcheck"
  }
}

resource "aws_cloudwatch_metric_alarm" "lb_r53_healthcheck_alarm_fargate" {
  count = "${local.enable_r53_hcs}"

  provider = "aws.cloudwatch"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn_cw}",
  ]

  alarm_name          = "${element(aws_route53_health_check.lb_r53_healthcheck_fargate.*.tags.Name, count.index)}"
  alarm_description   = "R53 healthcheck has become unhealthy for ${local.fargate_fqdn}}"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "10"
  period              = "60"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.lb_r53_healthcheck_fargate.*.id, count.index)}"
  }

  ok_actions = [
    "${local.sns_ok_arn_cw}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "lb_r53_healthcheck_alarm_ecs" {
  count = "${local.enable_r53_hcs}"

  provider = "aws.cloudwatch"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn_cw}",
  ]

  alarm_name          = "${element(aws_route53_health_check.lb_r53_healthcheck_ecs.*.tags.Name, count.index)}"
  alarm_description   = "R53 healthcheck has become unhealthy for ${local.ecs_fqdn}}"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "10"
  period              = "60"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.lb_r53_healthcheck_ecs.*.id, count.index)}"
  }

  ok_actions = [
    "${local.sns_ok_arn_cw}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "lb_r53_healthcheck_alarm_eks" {
  count = "${local.enable_r53_hcs}"

  provider = "aws.cloudwatch"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn_cw}",
  ]

  alarm_name          = "${element(aws_route53_health_check.lb_r53_healthcheck_eks.*.tags.Name, count.index)}"
  alarm_description   = "R53 healthcheck has become unhealthy for ${local.eks_fqdn}}"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "10"
  period              = "60"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.lb_r53_healthcheck_eks.*.id, count.index)}"
  }

  ok_actions = [
    "${local.sns_ok_arn_cw}",
  ]
}

resource "aws_cloudwatch_metric_alarm" "lb_r53_healthcheck_alarm_ec2" {
  count = "${local.enable_r53_hcs}"

  provider = "aws.cloudwatch"

  actions_enabled = "${local.enable_cloudwatch_alarm_actions}"

  alarm_actions = [
    "${local.sns_emergency_arn_cw}",
  ]

  alarm_name          = "${element(aws_route53_health_check.lb_r53_healthcheck_ec2.*.tags.Name, count.index)}"
  alarm_description   = "R53 healthcheck has become unhealthy for ${local.ec2_fqdn}}"
  statistic           = "Minimum"
  comparison_operator = "LessThanThreshold"
  threshold           = "1"
  evaluation_periods  = "10"
  period              = "60"
  metric_name         = "HealthCheckStatus"
  namespace           = "AWS/Route53"

  dimensions = {
    HealthCheckId = "${element(aws_route53_health_check.lb_r53_healthcheck_ec2.*.id, count.index)}"
  }

  ok_actions = [
    "${local.sns_ok_arn_cw}",
  ]
}
