# Variables

variable "default_tags" {
  type = "map"
}

variable "cluster_id" {}

variable "desired_count" {
  default = 1
}

variable "flaskapi_port" {
  default = "5000"
}

variable "alb_single_tg_arns" {
  type = "list"
}

# variable "flaskapi_repo_url" {}

variable "cpu" {
  default = 512
}

variable "memory" {
  default = 1024
}

variable "flaskapi_rds_instance_endpoint" {}
variable "flaskapi_sg_id" {}
variable "db_clients_sg_id" {}

variable "public_subnets" {
  type = "list"
}

variable "private_subnets" {
  type = "list"
}

# variable "ecs_role_arn" {}

variable "log_group_retention" {
  default = 3
}

variable "enable_ec2" {
  default = false
}

variable "log_group_name" {}

variable "image_version" {
  default = "latest"
}
