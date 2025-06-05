terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.0"
    }
  }
  required_version = ">= 1.0.0"
}

provider "aws" {
  region = var.aws_region
}

# Data sources
data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

# Networking Module
module "networking" {
  source = "../../modules/networking"
  
  project_name = var.project_name
  environment = var.environment
  vpc_cidr = var.vpc_cidr
  eks_cluster_names = var.eks_cluster_names
}

# CodeCommit Module
module "codecommit" {
  source = "../../modules/codecommit"
  
  project_name = var.project_name
  environment = var.environment
  repository_name = var.repository_name
}

# ECR Module
module "ecr" {
  source = "../../modules/ecr"
  
  project_name = var.project_name
  environment = var.environment
  ecr_repository_name = var.ecr_repository_name
}

# IAM Module
module "iam" {
  source = "../../modules/iam"
  
  project_name = var.project_name
  environment = var.environment
  codecommit_repository_arn = module.codecommit.repository_arn
}

# EKS Module
module "eks" {
  source = "../../modules/eks"
  
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.networking.vpc_id
  private_subnet_ids = module.networking.private_subnet_ids
  eks_cluster_names = var.eks_cluster_names
  eks_node_group_instance_types = var.eks_node_group_instance_types
  eks_node_group_desired_size = var.eks_node_group_desired_size
  eks_node_group_min_size = var.eks_node_group_min_size
  eks_node_group_max_size = var.eks_node_group_max_size
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn = module.iam.eks_node_role_arn
}

# CodeBuild Module
module "codebuild" {
  source = "../../modules/codebuild"
  
  project_name = var.project_name
  environment = var.environment
  codecommit_repository_arn = module.codecommit.repository_arn
  ecr_repository_url = module.ecr.repository_url
  codebuild_role_arn = module.iam.codebuild_role_arn
}

# CodePipeline Module
module "codepipeline" {
  source = "../../modules/codepipeline"
  
  project_name = var.project_name
  environment = var.environment
  codecommit_repository_name = module.codecommit.repository_name
  codebuild_project_name = module.codebuild.project_name
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  artifact_bucket_name = "${var.project_name}-${var.environment}-artifacts-${random_string.bucket_suffix.result}"
}

# Add random string for unique bucket naming
resource "random_string" "bucket_suffix" {
  length  = 8
  special = false
  upper   = false
}

# Data Science Modules
module "s3" {
  source = "../../modules/s3"
  
  project_name = var.project_name
  environment = var.environment
}

module "kinesis" {
  source = "../../modules/kinesis"
  
  project_name = var.project_name
  environment = var.environment
  shard_count = 2
  retention_period = 48
}

module "glue" {
  source = "../../modules/glue"
  
  project_name = var.project_name
  environment = var.environment
  s3_bucket_id = module.s3.bucket_id
  s3_bucket_arn = module.s3.bucket_arn
  kinesis_stream_arn = module.kinesis.stream_arn
  glue_role_arn = module.iam.glue_role_arn
  glue_job_timeout = var.glue_job_timeout
}

module "redshift" {
  source = "../../modules/redshift"
  
  project_name = var.project_name
  environment = var.environment
  vpc_id = module.networking.vpc_id
  subnet_ids = module.networking.private_subnet_ids
  security_group_ids = [module.networking.default_security_group_id]
}

module "sagemaker" {
  source = "../../modules/sagemaker"
  
  project_name = var.project_name
  environment = var.environment
  s3_bucket_arn = module.s3.bucket_arn
  subnet_id = module.networking.private_subnet_ids[0]
  security_group_ids = [module.networking.default_security_group_id]
  aws_account_id = data.aws_caller_identity.current.account_id
  aws_region = var.aws_region
  ecr_repository_name = var.ecr_repository_name
}


# Add this at the end of the file, after the existing modules

# QuickSight Module for Analytics and Dashboards
module "quicksight" {
  source = "../../modules/quicksight"
  
  project_name           = var.project_name
  environment            = var.environment
  notification_email     = var.quicksight_notification_email
  quicksight_edition     = var.quicksight_edition
  create_redshift_datasource = true
  create_s3_datasource   = true
  redshift_database_name = var.redshift_database_name
  redshift_cluster_endpoint = module.redshift.cluster_endpoint
  s3_bucket_name         = module.s3.bucket_name
}


## Integration with Environment Configuration

# To use these new modules in your environments, you can add them to your environment's `main.tf` 
# file. Here's an example for the dev environment:
# ```terraform```
# Add these modules to your existing main.tf

# EMR Module for big data processing
module "emr" {
  source = "../../modules/emr"
  
  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.networking.vpc_id
  subnet_id    = module.networking.private_subnet_ids[0]
  
  log_bucket   = module.s3.bucket_id
  data_bucket  = module.s3.bucket_id
}

# ALB Module for load balancing
module "alb" {
  source = "../../modules/alb"
  
  project_name     = var.project_name
  environment      = var.environment
  vpc_id           = module.networking.vpc_id
  subnet_ids       = module.networking.public_subnet_ids
  security_group_ids = [module.networking.alb_security_group_id]
  
  log_bucket       = module.s3.bucket_id
  
  target_groups = {
    app = {
      port        = 80
      protocol    = "HTTP"
      target_type = "ip"
      health_check_path = "/health"
    }
  }
  
  default_target_group_key = "app"
  create_http_listener     = true
}

# SNS Module for pub/sub messaging
module "sns" {
  source = "../../modules/sns"
  
  project_name = var.project_name
  environment  = var.environment
  topic_name   = "events"
  
  subscriptions = {
    lambda = {
      protocol = "lambda"
      endpoint = module.lambda.function_arn
    }
  }
}

# SQS Module for message queuing
module "sqs" {
  source = "../../modules/sqs"
  
  project_name = var.project_name
  environment  = var.environment
  queue_name   = "tasks"
  
  source_arns  = [module.sns.topic_arn]
}

# Route53 Module for DNS management
module "route53" {
  source = "../../modules/route53"
  
  project_name = var.project_name
  environment  = var.environment
  domain_name  = var.domain_name
  
  records = {
    "api" = {
      type    = "A"
      ttl     = 300
      records = [module.networking.nat_public_ips[0]]
    }
  }
  
  alias_records = {
    "www" = {
      type = "A"
      alias = {
        name    = module.cloudfront.distribution_domain_name
        zone_id = "Z2FDTNDATAQYW2" # CloudFront's hosted zone ID
      }
    }
  }
}

# ECS/Fargate Module for container orchestration
module "ecs" {
  source = "../../modules/ecs"
  
  project_name = var.project_name
  environment  = var.environment
  aws_region   = var.aws_region
  
  execution_role_arn = module.iam.ecs_execution_role_arn
  task_role_arn      = module.iam.ecs_task_role_arn
  
  container_name  = "${var.project_name}-container"
  container_image = "${module.ecr.repository_url}:latest"
  container_port  = 80
  
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.networking.ecs_security_group_id]
  
  environment_variables = {
    ENVIRONMENT = var.environment
    REGION      = var.aws_region
  }
}

# Step Functions Module for workflow orchestration
module "stepfunctions" {
  source = "../../modules/stepfunctions"
  
  project_name = var.project_name
  environment  = var.environment
  
  state_machine_role_arn = module.iam.step_functions_role_arn
}

# DynamoDB Module for NoSQL database
module "dynamodb" {
  source = "../../modules/dynamodb"
  
  project_name = var.project_name
  environment  = var.environment
  table_name   = "data-table"
  
  hash_key      = "id"
  hash_key_type = "S"
  
  attributes = [
    {
      name = "email"
      type = "S"
    },
    {
      name = "status"
      type = "S"
    }
  ]
  
  global_secondary_indexes = [
    {
      name            = "EmailIndex"
      hash_key        = "email"
      projection_type = "ALL"
    },
    {
      name            = "StatusIndex"
      hash_key        = "status"
      projection_type = "ALL"
    }
  ]
  
  point_in_time_recovery_enabled = true
}

# RDS Module for relational database
module "rds" {
  source = "../../modules/rds"
  
  project_name = var.project_name
  environment  = var.environment
  
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.networking.rds_security_group_id]
  
  db_name  = var.rds_database_name
  username = var.rds_username
  password = var.rds_password
  
  instance_class    = "db.t3.medium"
  allocated_storage = 20
  multi_az          = false
  
  backup_retention_period = 7
  deletion_protection     = true
}

# Lambda Module
module "lambda" {
  source = "../../modules/lambda"
  
  project_name = var.project_name
  environment  = "dev"
  handler      = "index.handler"
  runtime      = "nodejs18.x"
  s3_bucket    = module.s3.bucket_id
  s3_key       = "lambda/function.zip"
  
  subnet_ids         = module.networking.private_subnet_ids
  security_group_ids = [module.networking.lambda_sg_id]
  
  environment_variables = {
    ENVIRONMENT = "dev"
    REGION      = var.aws_region
  }
}

# CloudFront Module
module "cloudfront" {
  source = "../../modules/cloudfront"
  
  project_name        = var.project_name
  environment         = "dev"
  s3_origin_domain_name = module.s3.bucket_domain_name
  s3_origin_id        = module.s3.bucket_id
  s3_bucket_arn       = module.s3.bucket_arn
  s3_bucket_id        = module.s3.bucket_id
}
