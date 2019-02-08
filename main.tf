module "iam" {
  source = "./iam"

  default_tags = "${var.default_tags}"
}

module "alb_single" {
  source = "./alb_single"

  # Network
  vpc_id         = "${data.terraform_remote_state.flaskapi_base.vpc_id}"
  public_subnets = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"

  # DNS
  r53_dns_domain_pub = "${var.r53_dns_domain_pub}"
  zone_id_pub        = "${data.aws_route53_zone.zone_pub.id}"

  # ALB
  target_group_backend_protocol   = "${var.flaskapi_protocol}"
  target_group_backend_port       = "${var.flaskapi_port}"
  enable_route53_health_checks    = true
  enable_cloudwatch_alarm_actions = true
  https_listeners_count           = 1
  wildcard_cert_arn               = "${data.terraform_remote_state.flaskapi_base.wildcard_cert_arn}"

  # Security Groups
  sg_r53_id = "${data.terraform_remote_state.flaskapi_base.r53_hcs_sg_id}"
  sg_alb_id = "${data.terraform_remote_state.flaskapi_base.alb_sg_id}"

  # Tags
  default_tags = "${var.default_tags}"

  # Monitoring
  log_bucket_name        = "${data.terraform_remote_state.flaskapi_base.s3_lb_logs_id}"
  alb_logging_enabled    = "${var.alb_logging_enabled}"
  evaluate_target_health = "${var.evaluate_target_health}"
}

module "ecs_cluster" {
  source = "./ecs_cluster"

  # Tags
  default_tags = "${var.default_tags}"
}

module "fargate" {
  source = "./fargate"

  enable_fargate = false

  # ECS Cluster
  cluster_id = "${module.ecs_cluster.id}"

  #ALB
  alb_single_tg_arns = "${module.alb_single.tg_arns}"

  # Tags
  default_tags = "${var.default_tags}"

  # Image
  flaskapi_repo_url = "${data.terraform_remote_state.ecr.flaskapi_repository_url}"

  # Database
  flaskapi_rds_instance_endpoint = "${data.terraform_remote_state.database.flaskapi_rds_instance_endpoint}"

  # Network
  public_subnets  = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"
  private_subnets = "${data.terraform_remote_state.flaskapi_base.private_subnets_ids}"

  # Security Groups
  flaskapi_sg_id   = "${data.terraform_remote_state.flaskapi_base.flaskapi_sg_id}"
  db_clients_sg_id = "${data.terraform_remote_state.flaskapi_base.db_clients_sg_id}"
}

module "ecs_ec2" {
  source = "./ecs_ec2"

  enable_ec2 = true

  # Service 
  desired_count = 1

  # ECS Cluster
  cluster_id = "${module.ecs_cluster.id}"

  #ALB
  alb_single_tg_arns = "${module.alb_single.tg_arns}"

  # Tags
  default_tags = "${var.default_tags}"

  # Image
  flaskapi_repo_url = "${data.terraform_remote_state.ecr.flaskapi_repository_url}"

  # Database
  flaskapi_rds_instance_endpoint = "${data.terraform_remote_state.database.flaskapi_rds_instance_endpoint}"

  # Network
  public_subnets  = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"
  private_subnets = "${data.terraform_remote_state.flaskapi_base.private_subnets_ids}"

  # Security Groups
  flaskapi_sg_id   = "${data.terraform_remote_state.flaskapi_base.flaskapi_sg_id}"
  db_clients_sg_id = "${data.terraform_remote_state.flaskapi_base.db_clients_sg_id}"

  # IAM
  # ecs_role_arn = "${module.iam.ecs_role_arn}"
}

module "ec2_nodes" {
  source = "./ec2_nodes"

  # ECS Cluster
  cluster_id = "${module.ecs_cluster.id}"

  # Network
  vpc_id          = "${data.terraform_remote_state.flaskapi_base.vpc_id}"
  private_subnets = "${data.terraform_remote_state.flaskapi_base.private_subnets_ids}"
  public_subnets  = "${data.terraform_remote_state.flaskapi_base.public_subnets_ids}"

  # Instance
  instance_type         = "${var.instance_type}"
  instance_count        = "${var.instance_count}"
  instance_profile_name = "${module.iam.ecs_instance_profile_name}"
  ami_id                = "${data.aws_ami.amazon_ecs.image_id}"
  key_name              = "${var.key_name}"
  disable_api_term      = "${var.disable_api_term}"
  ebs_optimized         = "${var.ebs_optimized}"

  # Security Groups
  tux_sg_id = "${data.terraform_remote_state.flaskapi_base.tux_sg_id}"

  # Tags
  default_tags   = "${var.default_tags}"
  enable_backups = "${var.enable_backups}"
  enable_chef    = "${var.enable_chef}"

  # Monitoring 
  enable_cw_metrics        = "${var.enable_cw_metrics}"
  enable_monitoring        = "${var.enable_monitoring}"
  enable_cw_alarm_cpu      = "${var.enable_cw_alarm_cpu}"
  enable_cw_alarm_disk_tux = "${var.enable_cw_alarm_disk_tux}"
  log_group_retention      = "${var.log_group_retention}"
}
