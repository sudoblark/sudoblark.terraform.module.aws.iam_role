terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.61.0"
    }
  }
  required_version = "~> 1.5.0"
}

provider "aws" {
  region = "eu-west-2"
}

module "iam_role" {
  source = "github.com/sudoblark/sudoblark.terraform.module.aws.iam_role?ref=1.0.0"

  application_name = var.application_name
  environment      = var.environment
  raw_iam_roles    = local.raw_iam_roles

}