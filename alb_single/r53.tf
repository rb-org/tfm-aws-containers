resource "aws_route53_record" "main" {
  count   = "${length(local.https_listener_ssl_cert_names)}"
  zone_id = "${var.zone_id_pub}"
  name    = "${local.https_listener_ssl_cert_names[count.index]}"
  type    = "A"

  alias {
    name                   = "${module.alb.dns_name}"
    zone_id                = "${module.alb.load_balancer_zone_id}"
    evaluate_target_health = "${local.evaluate_target_health}"
  }
}
