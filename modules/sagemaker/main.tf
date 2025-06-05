resource "aws_sagemaker_notebook_instance" "notebook" {
  name                    = "${var.project_name}-${var.environment}-notebook"
  role_arn                = aws_iam_role.sagemaker_role.arn
  instance_type           = var.notebook_instance_type
  volume_size             = var.notebook_volume_size
  subnet_id               = var.subnet_id
  security_groups         = var.security_group_ids
  direct_internet_access  = "Disabled"

  tags = {
    Name        = "${var.project_name}-notebook"
    Environment = var.environment
  }
}

# IAM Role for SageMaker
resource "aws_iam_role" "sagemaker_role" {
  name = "${var.project_name}-${var.environment}-sagemaker-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-sagemaker-role"
    Environment = var.environment
  }
}

# Attach policies to SageMaker role
resource "aws_iam_role_policy_attachment" "sagemaker_full_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  role       = aws_iam_role.sagemaker_role.name
}

resource "aws_iam_role_policy_attachment" "s3_access" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
  role       = aws_iam_role.sagemaker_role.name
}

# SageMaker Model
resource "aws_sagemaker_model" "model" {
  name               = "${var.project_name}-${var.environment}-model"
  execution_role_arn = aws_iam_role.sagemaker_role.arn

  primary_container {
    image = "${var.aws_account_id}.dkr.ecr.${var.aws_region}.amazonaws.com/${var.ecr_repository_name}:latest"
  }

  tags = {
    Name        = "${var.project_name}-model"
    Environment = var.environment
  }
}