resource "aws_ssm_parameter" "cw_agent_cfg" {
  name      = "${local.cw_agent_ssm_path}"
  overwrite = true
  type      = "String"
  value     = "${data.template_file.cw_agent_tux.rendered}"
}

data "template_file" "cw_agent_tux" {
  template = "${file("./files/cw_agent_tux.tpl")}"

  vars {
    instance_name = "${local.instance_name}"
    log_prefix    = "xyz"
  }
}
