# Variables

variable "default_tags" {
  type = "map"
}

variable "desired_count" {
  default = 1
}

variable "flaskapi_port" {
  default = "5000"
}

variable "alb_single_tg_arns" {
  type = "list"
}

variable "flaskapi_repo_url" {}

variable "cpu" {
  default = 512
}

variable "memory" {
  default = 1024
}

variable "flaskapi_rds_instance_endpoint" {}
