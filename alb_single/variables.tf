##############
# General
##############

variable "vpc_id" {
  description = "Required"
}

variable "name_suffix" {
  description = "Required: "
  default     = ""
}

##############
# DNS & R53
##############
variable "zone_id_pub" {}

variable "r53_dns_domain_pub" {
  description = "Required: "
}

##############
# ALB
##############
variable "extra_security_groups" {
  type    = "list"
  default = [""]
}

variable "public_subnets" {
  type        = "list"
  default     = [""]
  description = "Required: for external facing LBs this is a list of public subnets"
}

variable "enable_deletion_protection" {
  default = false
}

variable "enable_http2" {
  default = true
}

variable "http_tcp_listeners" {
  type    = "list"
  default = [""]
}

variable "http_tcp_listeners_count" {
  default = 0
}

variable "https_listeners_ports" {
  type    = "list"
  default = [443]
}

variable "https_listeners_count" {
  default = 0
}

variable "idle_timeout" {
  default = 60
}

variable "ip_address_type" {
  default = "ipv4"
}

variable "listener_ssl_policy_default" {
  default = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "load_balancer_create_timeout" {
  default = "10m"
}

variable "load_balancer_delete_timeout" {
  default = "10m"
}

variable "load_balancer_is_internal" {
  default = false
}

variable "load_balancer_update_timeout" {
  default = "10m"
}

variable "target_groups" {
  type    = "list"
  default = [""]
}

variable "target_groups_count" {
  default = 0
}

variable "target_group_backend_protocol" {
  default = "HTTP"
}

variable "target_group_backend_port" {
  default = "80"
}

# variable "tg_backend_protocol" {
#   type = "map"

#   default = {
#     xld = "HTTPS"
#     xlr = "HTTPS"
#   }
# }

# variable "tg_backend_port" {
#   type = "map"

#   default = {
#     xld = "4516"
#     xlr = "5516"
#   }
# }

variable "cookie_duration" {
  default = 86400
}

variable "deregistration_delay" {
  default = 300
}

variable "health_check_healthy_threshold" {
  default = 3
}

variable "health_check_interval" {
  default = 10
}

variable "health_check_matcher" {
  default = "200-302"
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_port" {
  default = "traffic-port"
}

variable "health_check_timeout" {
  default = 5
}

variable "health_check_unhealthy_threshold" {
  default = 5
}

variable "stickiness_enabled" {
  default = true
}

variable "target_type" {
  default = "ip"
}

##############
# Tags
##############
variable "default_tags" {
  type = "map"
}

##############
# Security Groups
##############

variable "allowed_ips" {
  type    = "list"
  default = ["1.1.1.1/32"]
}

variable "sg_r53_id" {}
variable "sg_alb_id" {}

##############
# Logging
##############

variable "alb_logging_enabled" {}

variable "log_bucket_name" {}

variable "log_location_prefix" {
  default = ""
}

##############
# Instances
##############

# variable "instance_count" {}

# variable "instance_ids_xld" {
#   type = "list"
# }

##############
# Cloudwatch
##############
variable "enable_route53_health_checks" {}

# variable "app_id" {
#   default = ""
# }

variable "evaluate_target_health" {}

variable "enable_cloudwatch_alarm_actions" {}

variable "lb_unhealthy_hosts_alarm_evaluation_periods" {
  default = "10"
}

variable "lb_unhealthy_hosts_alarm_period" {
  default = "60"
}

variable "lb_unhealthy_hosts_alarm_threshold" {
  default = "1"
}

variable "r53_healhcheck_type" {
  default = "HTTPS"
}

variable "r53_healhcheck_port" {
  default = 443
}

variable "r53_healhcheck_resource_path" {
  default = "/"
}

variable "r53_healhcheck_request_interval" {
  default = 30
}

variable "r53_healhcheck_failure_threshold" {
  default = 5
}

variable "r53_healhcheck_stringmatch" {
  default = ""
}

# certs
variable "wildcard_cert_arn" {}
