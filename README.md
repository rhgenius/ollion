# AWS DevOps and Data Science Infrastructure with Terraform
This repository contains Terraform code to deploy a complete AWS DevOps and Data Science infrastructure including networking, EKS clusters, IAM roles, CodeCommit, CodeBuild, CodePipeline, ECR resources, and data science components like S3, Kinesis, Glue, Redshift, and SageMaker.

## Project Structure
```
/
├── .gitignore
├── README.md
├── docs/
│   ├── architecture.md
│   ├── deployment-guide.md
│   └── troubleshooting.md
├── environments/
│   ├── dev/
│   │   ├── backend.tf
│   │   ├── graph.png
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── plan.out
│   │   └── variables.tf
│   ├── production/
│   │   ├── backend.tf
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── staging/
│       ├── backend.tf
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── modules/
│   ├── alb/             # AWS Application Load Balancer module
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── cloudfront/      # AWS CloudFront module for content delivery
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── codebuild/       # AWS CodeBuild module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── codecommit/      # AWS CodeCommit module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── codepipeline/    # AWS CodePipeline module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── dynamodb/        # AWS DynamoDB module for NoSQL database
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ecr/             # AWS ECR module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── ecs/             # AWS ECS module for container orchestration
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── eks/             # AWS EKS module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── emr/             # AWS EMR module for big data processing
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── glue/            # AWS Glue module for ETL
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── iam/             # AWS IAM module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── kinesis/         # AWS Kinesis module for data streaming
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── lambda/          # AWS Lambda module for serverless functions
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── networking/      # AWS VPC and networking module
│   │   ├── README.md
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── quicksight/      # AWS QuickSight module for BI and visualization
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── rds/             # AWS RDS module for relational databases
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── redshift/        # AWS Redshift module for data warehousing
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── route53/         # AWS Route53 module for DNS management
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── s3/              # AWS S3 module for object storage
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── sagemaker/       # AWS SageMaker module for ML
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── sns/             # AWS SNS module for notifications
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── sqs/             # AWS SQS module for message queuing
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── stepfunctions/   # AWS Step Functions module for workflow orchestration
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── scripts/
│   ├── deploy.sh
│   ├── destroy.sh
│   └── validate.sh
├── templates/
│   ├── appspec.yaml.template
│   ├── buildspec.yml
│   └── taskdef.json.template
└── terraform.tfvars.example
```

## GCP to AWS Service Mapping

### DevOps Components
| GCP Service | AWS Equivalent |
|-------------|---------------|
| Google Kubernetes Engine (GKE) | Amazon Elastic Kubernetes Service (EKS) |
| Cloud Source Repositories | AWS CodeCommit |
| Cloud Build | AWS CodeBuild |
| Cloud Deploy | AWS CodePipeline |
| Container Registry | Amazon Elastic Container Registry (ECR) |
| Cloud IAM | AWS Identity and Access Management (IAM) |
| Virtual Private Cloud (VPC) | Amazon Virtual Private Cloud (VPC) |

### Data Science Components
| GCP Service | AWS Equivalent |
|-------------|---------------|
| Cloud Storage | Amazon Simple Storage Service (S3) |
| Pub/Sub | Amazon Kinesis, Amazon MSK |
| Dataflow | AWS Glue, Amazon EMR |
| BigQuery | Amazon Redshift, Amazon Athena |
| Vertex AI | Amazon SageMaker |
| Cloud Composer | Amazon Managed Workflows for Apache Airflow (MWAA) |
| Cloud SQL | Amazon RDS |
| Cloud Spanner | Amazon DynamoDB |
| Data Catalog | AWS Glue Data Catalog |
| Cloud Workflows | AWS Step Functions |

### Machine Learning Components
| GCP Service | AWS Equivalent |
|-------------|---------------|
| Vertex AI | Amazon SageMaker |
| Vertex AI Workbench | Amazon SageMaker Studio |
| AutoML | Amazon SageMaker Autopilot |
| AI Platform Training | Amazon SageMaker Training |
| AI Platform Prediction | Amazon SageMaker Inference |
| Vertex AI Feature Store | Amazon SageMaker Feature Store |
| Vertex AI Model Registry | Amazon SageMaker Model Registry |
| Vertex AI Pipelines | Amazon SageMaker Pipelines |
| Vertex AI Experiments | Amazon SageMaker Experiments |
| Vertex AI TensorBoard | Amazon SageMaker Debugger |
| Explainable AI | Amazon SageMaker Clarify |
| AI Platform Notebooks | Amazon SageMaker Notebooks |
| Vision AI | Amazon Rekognition |
| Natural Language AI | Amazon Comprehend |
| Translation AI | Amazon Translate |
| Speech-to-Text | Amazon Transcribe |
| Text-to-Speech | Amazon Polly |
| Document AI | Amazon Textract |
| Contact Center AI | Amazon Connect with AI capabilities |
| Dialogflow | Amazon Lex |
| Video Intelligence API | Amazon Rekognition Video |
| Cloud TPU | AWS Trainium/Inferentia |
| Deep Learning VM Images | AWS Deep Learning AMIs |
| Deep Learning Containers | AWS Deep Learning Containers |

## Module Descriptions
### Networking Module
Creates a VPC with public and private subnets, internet gateway, NAT gateway, and route tables for secure network architecture.

### IAM Module
Sets up IAM roles and policies for services like EKS, CodeBuild, CodePipeline, and data science services with least privilege permissions.

### EKS Module
Deploys Amazon EKS clusters with worker nodes for container orchestration.

### CodeCommit Module
Sets up Git repositories for source code management.

### CodeBuild Module
Configures build projects for continuous integration.

### CodePipeline Module
Creates CI/CD pipelines with source and build stages.

### ECR Module
Sets up container registries for storing Docker images.

### S3 Module
Creates S3 buckets for data storage with appropriate configurations for data lakes.

### Kinesis Module
Sets up Kinesis streams for real-time data ingestion and processing.

### Glue Module
Configures AWS Glue for ETL jobs, data catalogs, and data integration.

### Redshift Module
Deploys Amazon Redshift clusters for data warehousing and analytics.

### SageMaker Module
Sets up Amazon SageMaker for machine learning model training, tuning, and deployment with appropriate instance types, storage configurations, and network settings. Includes notebook instances for development, training jobs for model building, and endpoints for inference.

### ALB Module
Provisions Application Load Balancers to distribute incoming application traffic across multiple targets, such as EC2 instances, containers, and IP addresses.

### CloudFront Module
Sets up Amazon CloudFront for content delivery network (CDN) services to securely deliver data, videos, applications, and APIs with low latency and high transfer speeds.

### DynamoDB Module
Deploys Amazon DynamoDB tables for NoSQL database needs with appropriate capacity modes, indexes, and backup configurations.

### ECS Module
Sets up Amazon Elastic Container Service for running, stopping, and managing Docker containers on a cluster with appropriate task definitions and services.

### EMR Module
Deploys Amazon EMR clusters for big data processing and analysis using frameworks like Apache Spark, Hadoop, HBase, and Presto.

### Lambda Module
Configures AWS Lambda functions for serverless compute, including function code, runtime environments, memory allocations, and execution roles.

### QuickSight Module
Sets up Amazon QuickSight for business intelligence and data visualization with appropriate datasets, analyses, and dashboards.

### RDS Module
Deploys Amazon RDS database instances with appropriate engine configurations, storage options, backup settings, and security groups.

### Route53 Module
Configures Amazon Route 53 for DNS management, including domain registration, routing policies, health checks, and DNS record sets.

### SNS Module
Sets up Amazon Simple Notification Service for pub/sub messaging and mobile notifications with appropriate topics, subscriptions, and delivery policies.

### SQS Module
Deploys Amazon Simple Queue Service for message queuing with appropriate queue types, message retention, visibility timeout, and dead-letter queue configurations.

### Step Functions Module
Configures AWS Step Functions for coordinating multiple AWS services into serverless workflows with appropriate state machines, task definitions, and error handling.

### Machine Learning Pipeline Module
Orchestrates end-to-end ML workflows connecting data ingestion (S3, Kinesis), processing (Glue), feature engineering, model training (SageMaker), and deployment with appropriate IAM permissions and monitoring.

### AI Services Module
Integrates AWS AI services like Rekognition (vision), Comprehend (NLP), Transcribe (speech-to-text), and Polly (text-to-speech) with the data pipeline for specialized ML capabilities without custom model development.

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or newer
- Git

## Quick Start
1. Clone this repository
2. Navigate to the desired environment directory
3. Run the validation script to ensure configuration is correct
```bash
./scripts/validate.sh
```
4. Run the deployment script to create the infrastructure
```bash
./scripts/deploy.sh
```
Note: Ensure to replace the example values in terraform.tfvars.example with your specific configurations. And empty backend.tf file if you use local backend.

## Architecture Diagram
The architecture diagram illustrates the high-level components and their interactions in the infrastructure.
## Deployment Guide
This guide provides detailed instructions on how to deploy the infrastructure using Terraform.

## Deployment Instructions
### For Each Environment (dev, staging, production)
1. Navigate to the environment directory:
2. Initialize Terraform:
3. Validate the configuration:
4. Format the code (optional):
5. Plan the deployment:
6. Apply the changes:

## Validation Script
The repository includes a validation script ( scripts/validate.sh ) that performs the following checks for each environment:

- Initializes Terraform without backend configuration
- Validates the Terraform configuration
- Checks the formatting of Terraform files
To use the script:
```
./scripts/validate.sh
```

This script helps ensure that all environments have valid configurations before deployment.

## Common Issues and Solutions
### 1. "Unsupported argument" Error
Problem: When modules are referenced but not properly defined.

Solution: Ensure all modules have proper variables.tf, main.tf, and outputs.tf files with appropriate definitions.

### 2. "Value for unconfigurable attribute" Error
Problem: When trying to set attributes that are managed by AWS or deprecated.

Solution: Remove the deprecated attributes (e.g., domain = "vpc" in aws_eip.nat).

### 3. "Missing resource instance key" Error
Problem: When referencing resources with count without specifying the index.

Solution: Use proper index notation (e.g., change aws_eip.nat.id to aws_eip.nat[count.index].id).

## Cleanup
To destroy the infrastructure:
```bash
./scripts/destroy.sh
```
## Troubleshooting
For detailed troubleshooting, refer to the troubleshooting guide in the docs directory.
## Best Practices Implemented
1. Modular Design: Code is organized into reusable modules for better maintainability.
2. Environment Separation: Different environments (dev, staging, production) are isolated.
3. Least Privilege: IAM roles follow the principle of least privilege.
4. Resource Naming: Consistent naming conventions across resources.
5. Validation: Pre-deployment validation to catch errors early.
6. Data Pipeline Integration: Seamless integration between data ingestion, processing, storage, and analytics components.
7. Scalable Architecture: Infrastructure designed to scale with growing data needs.
