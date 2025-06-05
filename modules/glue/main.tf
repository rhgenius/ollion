resource "aws_glue_catalog_database" "data_catalog" {
  name        = "${var.project_name}_${var.environment}_catalog"
  description = "Data catalog for ${var.project_name} ${var.environment}"
}

resource "aws_glue_crawler" "s3_crawler" {
  name          = "${var.project_name}-${var.environment}-s3-crawler"
  role          = var.glue_role_arn
  database_name = aws_glue_catalog_database.data_catalog.name

  s3_target {
    path = "s3://${var.s3_bucket_id}/data/"
  }

  schedule = "cron(0 0 * * ? *)"

  schema_change_policy {
    delete_behavior = "LOG"
    update_behavior = "UPDATE_IN_DATABASE"
  }

  tags = {
    Name        = "${var.project_name}-s3-crawler"
    Environment = var.environment
  }
}

resource "aws_glue_job" "etl_job" {
  name     = "${var.project_name}-${var.environment}-etl-job"
  role_arn = var.glue_role_arn

  command {
    name            = "glueetl"
    script_location = "s3://${var.s3_bucket_id}/scripts/etl_job.py"
    python_version  = "3"
  }

  max_retries      = 1
  timeout          = var.glue_job_timeout
  worker_type      = "G.1X"
  number_of_workers = 2

  default_arguments = {
    "--job-language"               = "python"
    "--continuous-log-logGroup"    = "/aws-glue/jobs/logs"
    "--enable-continuous-cloudwatch-log" = "true"
    "--enable-metrics"             = "true"
  }

  tags = {
    Name        = "${var.project_name}-etl-job"
    Environment = var.environment
  }
}