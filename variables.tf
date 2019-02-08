variable "region" {
  description = "AWS Region"
  default     = "eu-west-1"
}

variable "account_id" {
  description = "AWS Account ID"
  default     = ""
}

variable "default_tags" {
  type        = "map"
  description = "Map of default tags applied to all resources"

  default = {
    Github-Repo = "rb-org/tfm-aws-containers"
    Terraform   = "true"
  }
}

variable "remote_state_s3" {
  default = "xyz-tfm-state"
}

variable "r53_dns_domain_pub" {}

variable "evaluate_target_health" {
  default = true
}

variable "alb_logging_enabled" {
  default = true
}

variable "flaskapi_port" {
  default = "5000"
}

variable "flaskapi_protocol" {
  default = "HTTP"
}

# EC2
variable "instance_type" {
  type = "map"

  default = {
    ecs = "t3.medium"
  }
}

variable "instance_count" {
  type = "map"

  default = {
    ecs = 1
  }
}

variable "key_name" {
  default = "x200-euw"
}

# Monitoring 
variable "enable_cw_metrics" {
  type = "map"

  default = {
    ecs = false
  }
}

variable "enable_monitoring" {
  type = "map"

  default = {
    ecs = false
  }
}

variable "enable_cw_alarm_cpu" {
  description = "If true, the launched EC2 instance will have create cpu alarms"
  type        = "map"

  default = {
    ecs = false
  }
}

variable "enable_cw_alarm_disk_tux" {
  description = "If true, the launched EC2 instance will have create disk alarms"
  type        = "map"

  default = {
    ecs = false
  }
}

variable "log_group_retention" {
  type = "map"

  default = {
    x200 = 3
  }
}

# Instance Vars

variable "disable_api_term" {
  type = "map"

  default = {
    ecs = false
  }
}

variable "enable_backups" {
  type = "map"

  default = {
    ecs = "false"
  }
}

variable "enable_chef" {
  type = "map"

  default = {
    ecs = "false"
  }
}

variable "ebs_optimized" {
  type = "map"

  default = {
    ecs = "false"
  }
}
