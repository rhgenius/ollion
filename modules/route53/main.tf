resource "aws_route53_zone" "main" {
  name = var.domain_name
  comment = "${var.project_name}-${var.environment} managed zone"
  
  tags = {
    Name        = "${var.project_name}-zone"
    Environment = var.environment
  }
}

resource "aws_route53_record" "records" {
  for_each = var.records
  
  zone_id = aws_route53_zone.main.zone_id
  name    = each.key
  type    = each.value.type
  ttl     = lookup(each.value, "ttl", 300)
  records = each.value.records
}

# Conditional creation of alias records
resource "aws_route53_record" "alias_records" {
  for_each = var.alias_records
  
  zone_id = aws_route53_zone.main.zone_id
  name    = each.key
  type    = each.value.type
  
  alias {
    name                   = each.value.alias.name
    zone_id                = each.value.alias.zone_id
    evaluate_target_health = lookup(each.value.alias, "evaluate_target_health", false)
  }
}