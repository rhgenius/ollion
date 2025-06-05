# SQS Queue
resource "aws_sqs_queue" "queue" {
  name                        = "${var.project_name}-${var.environment}-queue${var.fifo_queue ? ".fifo" : ""}"
  delay_seconds               = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  fifo_queue                 = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  
  # Replace dynamic block with conditional attribute
  redrive_policy = var.enable_dead_letter_queue ? jsonencode({
    deadLetterTargetArn = aws_sqs_queue.dead_letter_queue[0].arn
    maxReceiveCount     = var.max_receive_count
  }) : null
  
  # Replace dynamic block with conditional attribute
  fifo_throughput_limit = var.fifo_queue ? var.fifo_throughput_limit : null
  
  # Replace dynamic block with conditional attribute
  deduplication_scope = var.fifo_queue ? var.deduplication_scope : null
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-queue"
    Environment = var.environment
  }
}

# SQS Queue Policy
resource "aws_sqs_queue_policy" "queue_policy" {
  queue_url = aws_sqs_queue.queue.url
  policy    = data.aws_iam_policy_document.queue_policy.json
}

data "aws_iam_policy_document" "queue_policy" {
  statement {
    sid    = "DefaultSQSPolicy"
    effect = "Allow"
    
    principals {
      type        = "AWS"
      identifiers = concat(["*"], var.additional_policy_principals)
    }
    
    actions = [
      "sqs:SendMessage",
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
      "sqs:GetQueueUrl"
    ]
    
    resources = [aws_sqs_queue.queue.arn]
    
    condition {
      test     = "ArnEquals"
      variable = "aws:SourceArn"
      values   = var.source_arns
    }
  }
  
  dynamic "statement" {
    for_each = var.additional_policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = [aws_sqs_queue.queue.arn]
      
      principals {
        type        = statement.value.principal_type
        identifiers = statement.value.principal_identifiers
      }
      
      dynamic "condition" {
        for_each = statement.value.conditions
        content {
          test     = condition.value.test
          variable = condition.value.variable
          values   = condition.value.values
        }
      }
    }
  }
}

# Dead Letter Queue
resource "aws_sqs_queue" "dead_letter_queue" {
  count = var.enable_dead_letter_queue ? 1 : 0
  
  name                        = "${var.project_name}-${var.environment}-dlq${var.fifo_queue ? ".fifo" : ""}"
  delay_seconds               = var.delay_seconds
  max_message_size           = var.max_message_size
  message_retention_seconds  = var.message_retention_seconds
  receive_wait_time_seconds  = var.receive_wait_time_seconds
  visibility_timeout_seconds = var.visibility_timeout_seconds
  fifo_queue                 = var.fifo_queue
  content_based_deduplication = var.content_based_deduplication
  
  # DLQ doesn't need its own DLQ
  
  # Conditional attributes for FIFO queues
  fifo_throughput_limit = var.fifo_queue ? var.fifo_throughput_limit : null
  deduplication_scope   = var.fifo_queue ? var.deduplication_scope : null
  
  tags = {
    Name        = "${var.project_name}-${var.environment}-dlq"
    Environment = var.environment
  }
}