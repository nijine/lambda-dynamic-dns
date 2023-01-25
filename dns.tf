data "aws_route53_zone" "primary" {
  name         = "${local.domain_name}."
  private_zone = false
}

resource "aws_route53_record" "record" {
  zone_id = data.aws_route53_zone.primary.zone_id
  name    = "${local.server}.${local.domain_name}"
  type    = "A"
  ttl     = 60
  records = ["1.2.3.4"] # starting value

  lifecycle {
    ignore_changes = [records]
  }
}
