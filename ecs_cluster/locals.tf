locals {
  name_prefix  = "${terraform.workspace}"
  cluster_name = "${local.name_prefix}-flaskapi"
}
