#!/bin/bash

# Destroy script for Terraform infrastructure

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if environment is provided
if [ $# -eq 0 ]; then
    print_error "Please provide an environment (dev, staging, production)"
    echo "Usage: $0 <environment>"
    exit 1
fi

ENVIRONMENT=$1

# Validate environment
if [[ ! "$ENVIRONMENT" =~ ^(dev|staging|production)$ ]]; then
    print_error "Invalid environment. Use: dev, staging, or production"
    exit 1
fi

print_warning "WARNING: This will destroy all resources in the $ENVIRONMENT environment!"
read -p "Are you sure you want to continue? Type 'yes' to confirm: " -r
echo

if [[ $REPLY == "yes" ]]; then
    print_status "Destroying $ENVIRONMENT environment..."
    
    # Navigate to environment directory
    cd "environments/$ENVIRONMENT"
    
    # Destroy infrastructure
    terraform destroy -auto-approve
    
    print_status "Environment destroyed successfully!"
else
    print_warning "Destruction cancelled."
fi