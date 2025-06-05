# SNS Topic
resource "aws_sns_topic" "topic" {
  name = "${var.project_name}-${var.environment}-${var.topic_name}"
  
  display_name = var.display_name
  fifo_topic   = var.fifo_topic
  
  kms_master_key_id = var.kms_master_key_id
  
  tags = {
    Name        = "${var.project_name}-${var.topic_name}"
    Environment = var.environment
  }
}

# SNS Topic Policy
resource "aws_sns_topic_policy" "policy" {
  arn    = aws_sns_topic.topic.arn
  policy = data.aws_iam_policy_document.sns_topic_policy.json
}

data "aws_iam_policy_document" "sns_topic_policy" {
  statement {
    sid    = "DefaultSNSPolicy"
    effect = "Allow"
    
    principals {
      type        = "AWS"
      identifiers = concat(["*"], var.additional_policy_principals)
    }
    
    actions = [
      "SNS:Subscribe",
      "SNS:SetTopicAttributes",
      "SNS:RemovePermission",
      "SNS:Receive",
      "SNS:Publish",
      "SNS:ListSubscriptionsByTopic",
      "SNS:GetTopicAttributes",
      "SNS:DeleteTopic",
      "SNS:AddPermission",
    ]
    
    resources = [aws_sns_topic.topic.arn]
    
    condition {
      test     = "StringEquals"
      variable = "AWS:SourceOwner"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
  
  dynamic "statement" {
    for_each = var.additional_policy_statements
    content {
      sid       = statement.value.sid
      effect    = statement.value.effect
      actions   = statement.value.actions
      resources = [aws_sns_topic.topic.arn]
      
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

# SNS Subscriptions
resource "aws_sns_topic_subscription" "subscriptions" {
  for_each = var.subscriptions
  
  topic_arn = aws_sns_topic.topic.arn
  protocol  = each.value.protocol
  endpoint  = each.value.endpoint
  
  filter_policy = lookup(each.value, "filter_policy", null)
  
  # Replace dynamic block with conditional attribute
  redrive_policy = each.value.dead_letter_queue_arn != null ? jsonencode({
    deadLetterTargetArn = each.value.dead_letter_queue_arn
  }) : null
}

# Get current account ID
data "aws_caller_identity" "current" {}