module "cert" {
  # source = "../../terraform-aws-excp-misc//acm"
  source = "git@github.com:rb-org/tfm-aws-mod-misc//acm?ref=v0.0.1"

  domains = {
    "${var.r53_dns_domain_pub}." = "${local.ssl_cert_primary_name}"
  }

  ssl_cert_primary_name = "${local.ssl_cert_primary_name[0]}"
  tags                  = "${var.default_tags}"
}
