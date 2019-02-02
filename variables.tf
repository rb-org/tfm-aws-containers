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

variable "log_group_retention" {
  default = 3
}
