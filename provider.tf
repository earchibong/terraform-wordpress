# Terraform Block
terraform {
  required_version = ">= 1.0" # any version equal & above 0.14 like 0.15, 0.16 etc and < 1.xx
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

# Provider Block
 provider "aws" {
  # Name of the region in which your environment will be deployed
  region = var.region

  # Name of your AWS profile
  profile = var.profile
}