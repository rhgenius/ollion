output "zone_id" {
  description = "ID of the Route53 zone"
  value       = aws_route53_zone.main.zone_id
}

output "zone_name" {
  description = "Name of the Route53 zone"
  value       = aws_route53_zone.main.name
}

output "name_servers" {
  description = "Name servers for the Route53 zone"
  value       = aws_route53_zone.main.name_servers
}