output "topic_arn" {
  description = "ARN of the SNS topic"
  value       = aws_sns_topic.topic.arn
}

output "topic_id" {
  description = "ID of the SNS topic"
  value       = aws_sns_topic.topic.id
}

output "topic_name" {
  description = "Name of the SNS topic"
  value       = aws_sns_topic.topic.name
}

output "subscription_arns" {
  description = "ARNs of the SNS topic subscriptions"
  value       = { for k, v in aws_sns_topic_subscription.subscriptions : k => v.arn }
}