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