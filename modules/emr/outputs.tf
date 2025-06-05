output "cluster_id" {
  description = "ID of the EMR cluster"
  value       = aws_emr_cluster.cluster.id
}

output "cluster_name" {
  description = "Name of the EMR cluster"
  value       = aws_emr_cluster.cluster.name
}

output "master_public_dns" {
  description = "Public DNS of the master node"
  value       = aws_emr_cluster.cluster.master_public_dns
}

output "master_security_group_id" {
  description = "ID of the master security group"
  value       = aws_security_group.emr_master.id
}

output "slave_security_group_id" {
  description = "ID of the slave security group"
  value       = aws_security_group.emr_slave.id
}

output "service_role_arn" {
  description = "ARN of the EMR service role"
  value       = aws_iam_role.emr_service_role.arn
}

output "ec2_role_arn" {
  description = "ARN of the EMR EC2 role"
  value       = aws_iam_role.emr_ec2_role.arn
}