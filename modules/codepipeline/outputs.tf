output "pipeline_name" {
  description = "Name of the CodePipeline"
  value       = aws_codepipeline.app_pipeline.name
}

output "pipeline_arn" {
  description = "ARN of the CodePipeline"
  value       = aws_codepipeline.app_pipeline.arn
}

output "artifact_bucket_name" {
  description = "Name of the S3 artifacts bucket"
  value       = aws_s3_bucket.codepipeline_artifacts.bucket
}

output "artifact_bucket_arn" {
  description = "ARN of the S3 artifacts bucket"
  value       = aws_s3_bucket.codepipeline_artifacts.arn
}