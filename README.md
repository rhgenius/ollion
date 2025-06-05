# AWS DevOps Infrastructure with Terraform
This repository contains Terraform code to deploy a complete AWS DevOps infrastructure including networking, EKS clusters, IAM roles, CodeCommit, CodeBuild, CodePipeline, and ECR resources.

## Project Structure
```
/
├── environments/         # Environment-specific 
configurations
│   ├── dev/             # Development environment
│   ├── staging/         # Staging environment
│   └── production/      # Production environment
├── modules/             # Reusable Terraform 
modules
│   ├── codebuild/       # AWS CodeBuild module
│   ├── codecommit/      # AWS CodeCommit module
│   ├── codepipeline/    # AWS CodePipeline module
│   ├── ecr/             # AWS ECR module
│   ├── eks/             # AWS EKS module
│   ├── iam/             # AWS IAM module
│   └── networking/      # AWS VPC and networking 
module
├── scripts/             # Utility scripts
│   └── validate.sh      # Terraform validation 
script
├── docs/                # Documentation
└── templates/           # Template files
```
## Module Descriptions
### Networking Module
Creates a VPC with public and private subnets, internet gateway, NAT gateway, and route tables for secure network architecture.

### IAM Module
Sets up IAM roles and policies for services like EKS, CodeBuild, and CodePipeline with least privilege permissions.

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

## Prerequisites
- AWS CLI configured with appropriate credentials
- Terraform v1.0.0 or newer
- Git
## Quick Start
1. Clone this repository
2. Navigate to the desired environment directory
3. Run the validation script to ensure configuration is correct
```
./scripts/validate.sh
```
## Deployment Instructions
### For Each Environment (dev, staging, production)
1. Navigate to the environment directory:
```
cd environments/dev
```
2. Initialize Terraform:
```
terraform init
```
3. Validate the configuration:
```
terraform validate
```
4. Format the code (optional):
```
terraform fmt
```
5. Plan the deployment:
```
terraform plan -out=tfplan
```
6. Apply the changes:
```
terraform apply tfplan
```
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
Problem : When modules are referenced but not properly defined.

Solution : Ensure all modules have proper variables.tf , main.tf , and outputs.tf files with appropriate definitions.

### 2. "Value for unconfigurable attribute" Error
Problem : When trying to set attributes that are managed by AWS or deprecated.

Solution : Remove the deprecated attributes (e.g., domain = "vpc" in aws_eip.nat ).

### 3. "Missing resource instance key" Error
Problem : When referencing resources with count without specifying the index.

Solution : Use proper index notation (e.g., change aws_eip.nat.id to aws_eip.nat[count.index].id ).

## Cleanup
To destroy the infrastructure:

```
cd environments/<environment_name>
terraform destroy
```
## Best Practices Implemented
1. Modular Design : Code is organized into reusable modules for better maintainability.
2. Environment Separation : Different environments (dev, staging, production) are isolated.
3. Least Privilege : IAM roles follow the principle of least privilege.
4. Resource Naming : Consistent naming conventions across resources.
5. Validation : Pre-deployment validation to catch errors early.