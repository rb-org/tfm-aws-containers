locals {
  name_prefix    = "${terraform.workspace}"
  service_name   = "${local.name_prefix}-flaskapi-fargate"
  container_name = "${local.name_prefix}-flaskapi-fargate"
  account_id     = "${data.aws_caller_identity.current.account_id}"
  task_exec_role = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  task_name      = "${local.name_prefix}-flaskapi-fargate"
  log_group_name = "/${terraform.workspace}/flaskapi/fargate"

  local_count = "${var.enable_fargate ? 1:0}"
}
