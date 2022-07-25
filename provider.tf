terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
provider "aws" {
  region     = var.aws-region
  access_key = var.access-key
  secret_key = var.secret-key
}
