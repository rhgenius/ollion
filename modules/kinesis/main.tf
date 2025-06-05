resource "aws_kinesis_stream" "data_stream" {
  name             = "${var.project_name}-${var.environment}-data-stream"
  shard_count      = var.shard_count
  retention_period = var.retention_period

  shard_level_metrics = [
    "IncomingBytes",
    "OutgoingBytes",
    "IncomingRecords",
    "OutgoingRecords"
  ]

  tags = {
    Name        = "${var.project_name}-data-stream"
    Environment = var.environment
  }
}