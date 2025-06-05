output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "vpc_cidr_block" {
  description = "CIDR block of the VPC"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "IDs of the public subnets"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "IDs of the private subnets"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.main.id
}

output "nat_gateway_ids" {
  description = "IDs of the NAT Gateways"
  value       = aws_nat_gateway.main[*].id
}

output "default_security_group_id" {
  description = "ID of the default security group"
  value       = aws_security_group.default.id
}

output "alb_security_group_id" {
  description = "The ID of the security group for ALB"
  value       = aws_security_group.alb_sg.id
}

output "nat_public_ips" {
  description = "List of public Elastic IPs created for NAT Gateway"
  value       = aws_eip.nat.*.public_ip
}

output "ecs_security_group_id" {
  description = "The ID of the security group for ECS tasks"
  value       = aws_security_group.ecs_sg.id
}

output "rds_security_group_id" {
  description = "The ID of the security group for RDS"
  value       = aws_security_group.rds_sg.id
}

output "lambda_sg_id" {
  description = "The ID of the security group for Lambda functions"
  value       = aws_security_group.lambda_sg.id
}