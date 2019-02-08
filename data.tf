# Data Resources

data "aws_route53_zone" "zone_pub" {
  name         = "${var.r53_dns_domain_pub}."
  private_zone = false
}

data "aws_ami" "amazon_ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["*amazon-ecs-optimized*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }
}
