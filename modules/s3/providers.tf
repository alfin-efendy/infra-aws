provider "aws" {
  region = var.region
  default_tags {
    tags = {
      created-by  = "terraform"
    }
  }
}
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.57.0"
    }
  }
}
