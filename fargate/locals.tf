locals {
  name_prefix    = "${terraform.workspace}"
  cluster_name   = "${local.name_prefix}-flaskapi-fargate"
  service_name   = "${local.name_prefix}-flaskapi-fargate"
  container_name = "${local.name_prefix}-flaskapi"
  account_id     = "${data.aws_caller_identity.current.account_id}"
  task_exec_role = "arn:aws:iam::${local.account_id}:role/ecsTaskExecutionRole"
  task_name      = "${local.name_prefix}-flaskapi-fargate"
}
