terraform {
  backend "s3" {
    bucket         = "ollion-terraform-state-dev"
    key            = "dev/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
    dynamodb_table = "ollion-terraform-locks-dev"
  }
}