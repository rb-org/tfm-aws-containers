variable "workload" {
  default = "dev"
}

variable "default_tags" {
  type = "map"
}

variable "vpc_id" {}

variable "instance_type" {
  type = "map"
}

variable "instance_count" {
  type = "map"
}

variable "instance_profile_name" {}

variable "ami_id" {}

variable "key_name" {}

variable "private_subnets" {
  type = "list"
}

variable "public_subnets" {
  type = "list"
}

variable "app_id" {
  description = "The identifier of the application running on the instance"
  default     = "ecs"
}

variable "app_role" {
  default = "ecs-node"
}

# Patching Days
variable "linux_patch_day_0" {
  default = "Monday"
}

variable "linux_patch_day_1" {
  default = "Wednesday"
}

# Monitoring 
variable "enable_cw_metrics" {
  type = "map"
}

variable "enable_monitoring" {
  type = "map"
}

variable "enable_cw_alarm_cpu" {
  description = "If true, the launched EC2 instance will have create cpu alarms"
  type        = "map"
}

variable "enable_cw_alarm_disk_tux" {
  description = "If true, the launched EC2 instance will have create disk alarms"
  type        = "map"
}

variable "log_group_retention" {
  type = "map"
}

# Instance Vars

variable "disable_api_term" {
  type = "map"
}

variable "enable_backups" {
  type = "map"
}

variable "enable_chef" {
  type = "map"
}

variable "ebs_optimized" {
  type = "map"
}

# Security Groups
variable "tux_sg_id" {}

variable "cluster_id" {}
