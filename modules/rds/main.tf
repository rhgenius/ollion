# RDS Subnet Group
resource "aws_db_subnet_group" "subnet_group" {
  name        = "${var.project_name}-${var.environment}-subnet-group"
  description = "Subnet group for ${var.project_name} ${var.environment} RDS instance"
  subnet_ids  = var.subnet_ids
  
  tags = {
    Name        = "${var.project_name}-subnet-group"
    Environment = var.environment
  }
}

# RDS Parameter Group
resource "aws_db_parameter_group" "parameter_group" {
  name        = "${var.project_name}-${var.environment}-parameter-group"
  family      = var.parameter_group_family
  description = "Parameter group for ${var.project_name} ${var.environment} RDS instance"
  
  dynamic "parameter" {
    for_each = var.db_parameters
    content {
      name  = parameter.key
      value = parameter.value
    }
  }
  
  tags = {
    Name        = "${var.project_name}-parameter-group"
    Environment = var.environment
  }
}

# RDS Option Group (for engines that support it)
resource "aws_db_option_group" "option_group" {
  count = var.create_option_group ? 1 : 0
  
  name                     = "${var.project_name}-${var.environment}-option-group"
  option_group_description = "Option group for ${var.project_name} ${var.environment} RDS instance"
  engine_name              = var.engine
  major_engine_version     = var.major_engine_version
  
  dynamic "option" {
    for_each = var.db_options
    content {
      option_name = option.value.option_name
      
      dynamic "option_settings" {
        for_each = option.value.option_settings
        content {
          name  = option_settings.key
          value = option_settings.value
        }
      }
    }
  }
  
  tags = {
    Name        = "${var.project_name}-option-group"
    Environment = var.environment
  }
}

# RDS Instance
resource "aws_db_instance" "db_instance" {
  identifier           = "${var.project_name}-${var.environment}-db"
  engine               = var.engine
  engine_version       = var.engine_version
  instance_class       = var.instance_class
  allocated_storage    = var.allocated_storage
  storage_type         = var.storage_type
  storage_encrypted    = var.storage_encrypted
  kms_key_id           = var.kms_key_id
  db_name              = var.db_name
  username             = var.username
  password             = var.password
  port                 = var.port
  
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.subnet_group.name
  parameter_group_name   = aws_db_parameter_group.parameter_group.name
  option_group_name      = var.create_option_group ? aws_db_option_group.option_group[0].name : null
  
  backup_retention_period   = var.backup_retention_period
  backup_window             = var.backup_window
  maintenance_window        = var.maintenance_window
  multi_az                  = var.multi_az
  publicly_accessible       = var.publicly_accessible
  skip_final_snapshot       = var.skip_final_snapshot
  final_snapshot_identifier = "${var.project_name}-${var.environment}-final-snapshot"
  deletion_protection      = var.deletion_protection
  
  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? var.performance_insights_retention_period : null
  monitoring_interval                   = var.monitoring_interval
  monitoring_role_arn                   = var.monitoring_interval > 0 ? var.monitoring_role_arn : null
  
  apply_immediately = var.apply_immediately
  
  tags = {
    Name        = "${var.project_name}-db"
    Environment = var.environment
  }
}

# CloudWatch Alarms (optional)
resource "aws_cloudwatch_metric_alarm" "cpu_utilization_alarm" {
  count = var.create_cloudwatch_alarms ? 1 : 0
  
  alarm_name          = "${var.project_name}-${var.environment}-db-cpu-utilization"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = 2
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = 80
  alarm_description   = "This alarm monitors RDS CPU utilization"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.id
  }
  
  tags = {
    Name        = "${var.project_name}-db-cpu-alarm"
    Environment = var.environment
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_alarm" {
  count = var.create_cloudwatch_alarms ? 1 : 0
  
  alarm_name          = "${var.project_name}-${var.environment}-db-free-storage-space"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = 2
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = 300
  statistic           = "Average"
  threshold           = var.free_storage_space_threshold
  alarm_description   = "This alarm monitors RDS free storage space"
  alarm_actions       = var.alarm_actions
  ok_actions          = var.ok_actions
  
  dimensions = {
    DBInstanceIdentifier = aws_db_instance.db_instance.id
  }
  
  tags = {
    Name        = "${var.project_name}-db-storage-alarm"
    Environment = var.environment
  }
}