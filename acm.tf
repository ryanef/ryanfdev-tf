resource "aws_acm_certificate" "cert" {
  domain_name       = "${var.your_domain}"
  validation_method = "DNS"
  subject_alternative_names = ["*.${var.your_domain}"]

  tags = {
    Environment = "${var.your_domain}-${var.environment}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "cert" {

  certificate_arn         = aws_acm_certificate.cert.arn
  validation_record_fqdns = [for record in aws_route53_record.validation : record.fqdn]


}
resource "aws_route53_record" "validation" {

  for_each = {
    for item in aws_acm_certificate.cert.domain_validation_options : item.domain_name => {
      name   = item.resource_record_name
      record = item.resource_record_value
      type   = item.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.selected.zone_id

}

resource "aws_route53_record" "apex" {
  zone_id = data.aws_route53_zone.selected.id
  name    = var.your_domain
  type    = "A"

  alias {
    name="${module.cloudfront.domain_name}"
    zone_id = "Z2FDTNDATAQYW2"
    evaluate_target_health = false
  }
}
resource "aws_route53_record" "www" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "www"
  type    = "CNAME"
  ttl = "60"
  records = [aws_route53_record.apex.name]

}

