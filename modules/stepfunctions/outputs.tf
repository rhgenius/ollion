output "state_machine_id" {
  description = "ID of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.id
}

output "state_machine_arn" {
  description = "ARN of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.arn
}

output "state_machine_name" {
  description = "Name of the Step Functions state machine"
  value       = aws_sfn_state_machine.state_machine.name
}

output "log_group_name" {
  description = "Name of the CloudWatch log group"
  value       = aws_cloudwatch_log_group.step_functions_logs.name
}

output "event_rule_arn" {
  description = "ARN of the CloudWatch Events rule (if created)"
  value       = var.create_event_trigger ? aws_cloudwatch_event_rule.trigger[0].arn : null
}