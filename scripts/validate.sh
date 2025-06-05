#!/bin/bash

# Validation script for Terraform configuration

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

# Get the script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
PROJECT_DIR="$( dirname "$SCRIPT_DIR" )"

cd "$PROJECT_DIR"

print_status "Validating Terraform configurations..."

# Validate each environment
for env in dev staging production; do
    print_status "Validating $env environment..."
    cd "$PROJECT_DIR/environments/$env"
    
    # Initialize and validate
    terraform init -backend=false
    terraform validate
    
    # Format check
    terraform fmt -check
    
    cd "$PROJECT_DIR"
    print_status "$env environment validation completed"
done

print_status "All validations completed successfully!"