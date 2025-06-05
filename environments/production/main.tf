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
}

# S3 Module
module "s3" {
  source = "../../modules/s3"
  
  project_name = var.project_name
  environment = var.environment
  bucket_name = var.bucket_name
}

# EKS Module
module "eks" {
  source = "../../modules/eks"
  
  project_name = var.project_name
  environment = var.environment
  eks_cluster_names = var.eks_cluster_names
  eks_cluster_role_arn = module.iam.eks_cluster_role_arn
  eks_node_role_arn = module.iam.eks_node_role_arn
  private_subnet_ids = module.networking.private_subnet_ids
  eks_node_group_instance_types = var.eks_node_group_instance_types
  eks_node_group_desired_size = var.eks_node_group_desired_size
  eks_node_group_max_size = var.eks_node_group_max_size
  eks_node_group_min_size = var.eks_node_group_min_size
}

# CodeBuild Module
module "codebuild" {
  source = "../../modules/codebuild"
  
  project_name = var.project_name
  environment = var.environment
  codebuild_role_arn = module.iam.codebuild_role_arn
  ecr_repository_url = module.ecr.repository_url
}

# CodePipeline Module
module "codepipeline" {
  source = "../../modules/codepipeline"
  
  project_name = var.project_name
  environment = var.environment
  artifact_bucket_name = "${var.project_name}-${var.environment}-artifacts"
  codepipeline_role_arn = module.iam.codepipeline_role_arn
  codecommit_repository_name = module.codecommit.repository_name
  codebuild_project_name = module.codebuild.project_name
}

# Kinesis Module
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
  node_type = var.redshift_node_type
  number_of_nodes = var.redshift_number_of_nodes
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