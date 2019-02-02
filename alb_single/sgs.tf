##########
## Ingress
##########

resource "aws_security_group_rule" "ir_https_tcp" {
  count             = "${length(var.https_listeners_ports)}"
  type              = "ingress"
  from_port         = "${var.https_listeners_ports[count.index]}"
  to_port           = "${var.https_listeners_ports[count.index]}"
  protocol          = "tcp"
  cidr_blocks       = "${var.allowed_ips}"
  security_group_id = "${var.sg_alb_id}"
  description       = "ALB HTTPS Rule - Allowed IPs"
}

resource "aws_security_group_rule" "ir_r53_health_checks_tcp" {
  count                    = "${local.enable_r53_hcs}"
  type                     = "ingress"
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  source_security_group_id = "${var.sg_r53_id}"
  security_group_id        = "${var.sg_alb_id}"
  description              = "Route53 Health Check Rule"
}
