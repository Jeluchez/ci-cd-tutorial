
resource "aws_route53_zone" "public" {
  name = var.domain_name
    private_zone = false
  provider     = aws.account_route53
}

# create Certificate
resource "aws_acm_certificate" "my_cert" {
  domain_name       = var.domain_name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_route53_record" "cert_dns" {
  allow_overwrite = true
  name =  tolist(aws_acm_certificate.my_cert.domain_validation_options)[0].resource_record_name
  records = [tolist(aws_acm_certificate.my_cert.domain_validation_options)[0].resource_record_value]
  type = tolist(aws_acm_certificate.my_cert.domain_validation_options)[0].resource_record_type
  zone_id = aws_route53_zone.public.id
  ttl = 60
  provider = aws.account_route53
}


resource "aws_route53_record" "my_app" {
  zone_id = aws_route53_zone.public.zone_id
  name    = "${var.domain_name}.${aws_route53_zone.public.name}"
  type    = "A"
  alias {
    name                   = aws_alb.my_app.dns_name
    zone_id                = aws_alb.my_app.zone_id
    evaluate_target_health = false
  }
  provider = aws.account_route53
}

output "testing" {
  value = "Test this demo code by going to https://${aws_route53_record.myapp.fqdn} and checking your have a valid SSL cert"
}
resource "aws_acm_certificate_validation" "my_cert_validation" {
  certificate_arn = aws_acm_certificate.my_cert.arn
  validation_record_fqdns = [aws_route53_record.cert_dns.fqdn]
}   

