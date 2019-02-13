module "instance" {
  #source = "../../mods/tfm-aws-mod-ec2-default"

  source = "github.com/rb-org/tfm-aws-mod-ec2-default?ref=v0.0.1"

  instance_count          = "${var.instance_count[var.app_id]}"
  instance_name           = "${local.instance_name}"
  instance_type           = "${var.instance_type[var.app_id]}"
  instance_profile_name   = "${var.instance_profile_name}"
  ami_id                  = "${var.ami_id}"
  subnet_ids              = ["${var.private_subnets}"]
  key_pair                = "${var.key_name}"
  user_data               = "./files/userdata_amz.sh"
  use_prv_ip              = false
  public_ip               = false
  security_group_ids      = ["${aws_security_group.sg_ecs.id}", "${var.tux_sg_id}"]
  enable_monitoring       = "${var.enable_monitoring[var.app_id]}"
  ebs_optimized           = "${var.ebs_optimized[var.app_id]}"
  disable_api_termination = "${var.disable_api_term[var.app_id]}"
  root_volume_type        = "gp2"
  root_volume_size        = 50

  # CloudWatch Vars

  enable_cw_alarm_cpu      = "${var.enable_cw_alarm_cpu[var.app_id]}"
  enable_cw_alarm_disk_tux = "${var.enable_cw_alarm_disk_tux[var.app_id]}"
  enable_cw_metrics        = "${var.enable_cw_metrics[var.app_id]}"
  disk_namespace           = "CWAgent"
  disk_comparison_operator = "GreaterThanThreshold"
  disk_metric_desc         = "Low Disk Space"
  disk_metric_name         = "disk_used_percent"
  disk_threshold           = "75"
  disk_unit                = "Percent"
  diskspace_disks          = ["nvme0n1p1"]
  path                     = ["/"]

  ## Tags

  default_tags = "${merge(var.default_tags, 
      map(
        "Workspace",  format("%s", terraform.workspace),
        "ChefEnv",    "${terraform.workspace}",
        "EcsCluster", "${var.cluster_name}"
        )
      )}"
  app_role       = "${var.app_role}"
  app_id         = "${var.app_id}"
  backup_enabled = "${var.enable_backups[var.app_id]}"
  workload       = "${var.workload}"
  chef_enabled   = "${var.enable_chef[var.app_id]}"
  patch_group    = "amazon-${terraform.workspace}"
  patching_day1  = "${var.linux_patch_day_0}"
  patching_day2  = "${var.linux_patch_day_1}"
  os             = "amazon"

  # Userdata

  userdata_vars = {
    ecs_userdata = "${local.ecs_userdata}"
  }
}
