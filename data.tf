# Data Resources

data "aws_route53_zone" "zone_pub" {
  name         = "${var.r53_dns_domain_pub}."
  private_zone = false
}
