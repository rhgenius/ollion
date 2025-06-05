resource "aws_quicksight_account_subscription" "subscription" {
  account_name          = "${var.project_name}-${var.environment}"
  authentication_method = "IAM_AND_QUICKSIGHT"
  edition               = var.quicksight_edition
  notification_email    = var.notification_email
}

resource "aws_quicksight_group" "analysts" {
  group_name     = "${var.project_name}-${var.environment}-analysts"
  aws_account_id = data.aws_caller_identity.current.account_id
  namespace      = "default"
  description    = "Group for data analysts"

  depends_on = [aws_quicksight_account_subscription.subscription]
}

resource "aws_quicksight_data_source" "redshift" {
  count                   = var.create_redshift_datasource ? 1 : 0
  data_source_id          = "${var.project_name}-${var.environment}-redshift"
  name                    = "${var.project_name}-${var.environment}-redshift"
  aws_account_id          = data.aws_caller_identity.current.account_id
  type                    = "REDSHIFT"

  parameters {
    redshift {
      database = var.redshift_database_name
      host     = var.redshift_cluster_endpoint
      port     = 5439
    }
  }

  depends_on = [aws_quicksight_account_subscription.subscription]
}

resource "aws_quicksight_data_source" "s3" {
  count                   = var.create_s3_datasource ? 1 : 0
  data_source_id          = "${var.project_name}-${var.environment}-s3"
  name                    = "${var.project_name}-${var.environment}-s3"
  aws_account_id          = data.aws_caller_identity.current.account_id
  type                    = "S3"

  parameters {
    s3 {
      manifest_file_location {
        bucket = var.s3_bucket_name
        key    = "${var.project_name}-${var.environment}-manifest.json"
      }
    }
  }

  depends_on = [aws_quicksight_account_subscription.subscription]
}

data "aws_caller_identity" "current" {}