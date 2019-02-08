locals {
  name_prefix            = "${terraform.workspace}"
  ecs_role_name          = "${local.name_prefix}-ecs-role"
  ecr_access_policy_name = "${local.name_prefix}-ecr-access-policy"

  policy_arns = [
    "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM",
    "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess",
    "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role",
  ]
}
