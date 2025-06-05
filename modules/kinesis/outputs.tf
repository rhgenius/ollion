output "stream_id" {
  description = "The ID of the Kinesis stream"
  value       = aws_kinesis_stream.data_stream.id
}

output "stream_arn" {
  description = "The ARN of the Kinesis stream"
  value       = aws_kinesis_stream.data_stream.arn
}

output "stream_name" {
  description = "The name of the Kinesis stream"
  value       = aws_kinesis_stream.data_stream.name
}