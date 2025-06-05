# Step Functions State Machine
resource "aws_sfn_state_machine" "state_machine" {
  name     = "${var.project_name}-${var.environment}-state-machine"
  role_arn = var.state_machine_role_arn
  definition = var.definition_file != "" ? file(var.definition_file) : jsonencode({
    Comment = "${var.project_name} ${var.environment} state machine"
    StartAt = "FirstState"
    States = {
      "FirstState" = {
        Type = "Pass"
        End  = true
      }
    }
  })
  
  logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.step_functions_logs.arn}:*"
    include_execution_data = var.include_execution_data
    level                  = var.logging_level
  }
  
  tags = {
    Name        = "${var.project_name}-state-machine"
    Environment = var.environment
  }
}

# CloudWatch Log Group for Step Functions
resource "aws_cloudwatch_log_group" "step_functions_logs" {
  name              = "/aws/states/${var.project_name}-${var.environment}-state-machine"
  retention_in_days = var.log_retention_days
  
  tags = {
    Name        = "${var.project_name}-step-functions-logs"
    Environment = var.environment
  }
}

# CloudWatch Event Rule to trigger Step Functions (optional)
resource "aws_cloudwatch_event_rule" "trigger" {
  count = var.create_event_trigger ? 1 : 0
  
  name                = "${var.project_name}-${var.environment}-step-functions-trigger"
  description         = "Trigger for ${var.project_name} ${var.environment} Step Functions state machine"
  schedule_expression = var.event_schedule_expression
  
  tags = {
    Name        = "${var.project_name}-step-functions-trigger"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_event_target" "step_functions_target" {
  count = var.create_event_trigger ? 1 : 0
  
  rule      = aws_cloudwatch_event_rule.trigger[0].name
  arn       = aws_sfn_state_machine.state_machine.arn
  role_arn  = var.event_role_arn
  input     = var.event_input
}