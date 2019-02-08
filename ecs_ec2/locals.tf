locals {
  name_prefix    = "${terraform.workspace}"
  service_name   = "${local.name_prefix}-flaskapi-ec2"
  container_name = "${local.name_prefix}-flaskapi-ec2"
  account_id     = "${data.aws_caller_identity.current.account_id}"
  task_exec_role = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  task_name      = "${local.name_prefix}-flaskapi-ec2"
  log_group_name = "/${terraform.workspace}/flaskapi/ec2"
  local_count    = "${var.enable_ec2 ? 1:0}"
}
