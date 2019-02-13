# Data Resources

data "aws_route53_zone" "zone_pub" {
  name         = "${var.r53_dns_domain_pub}."
  private_zone = false
}

data "aws_ami" "amazon_ecs" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name = "name"

    # values = ["amzn-ami-*-amazon-ecs-optimized"]
    values = ["amzn2-ami-ecs-hvm*"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
