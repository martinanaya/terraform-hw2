terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

#Configure aws provider
provider "aws" {
  region = "us-west-2"
  profile = "manaya-cli"
}

module "vpc" {
  source = "./modules/terraform_vpc"
}

module "launchconf" {
  source = "./modules/terraform_launchconf"
}

module "autoscale" {
  source = "./modules/terraform_autoscale"
}
