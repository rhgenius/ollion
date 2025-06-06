terraform {
  backend "s3" {
    bucket         = "ollion-terraform-state-production"
    key            = "production/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "ollion-terraform-locks-production"
  }
}