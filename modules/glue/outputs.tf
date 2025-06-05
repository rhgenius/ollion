output "catalog_database_name" {
  description = "Name of the Glue catalog database"
  value       = aws_glue_catalog_database.data_catalog.name
}

output "crawler_name" {
  description = "Name of the Glue crawler"
  value       = aws_glue_crawler.s3_crawler.name
}

output "etl_job_name" {
  description = "Name of the Glue ETL job"
  value       = aws_glue_job.etl_job.name
}