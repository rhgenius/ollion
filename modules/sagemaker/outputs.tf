output "notebook_instance_name" {
  description = "Name of the SageMaker notebook instance"
  value       = aws_sagemaker_notebook_instance.notebook.name
}

output "notebook_instance_url" {
  description = "URL of the SageMaker notebook instance"
  value       = "https://${var.aws_region}.console.aws.amazon.com/sagemaker/home?region=${var.aws_region}#/notebook-instances/openNotebook/${aws_sagemaker_notebook_instance.notebook.name}?view=classic"
}

output "sagemaker_role_arn" {
  description = "ARN of the IAM role for SageMaker"
  value       = aws_iam_role.sagemaker_role.arn
}

output "model_name" {
  description = "Name of the SageMaker model"
  value       = aws_sagemaker_model.model.name
}