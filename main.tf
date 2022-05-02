terraform {
  # pinning to the latest version of Terraform
  required_version = ">= 0.14"
  backend "s3" {
    profile = "cloudmargin"
    region  = "us-east-1" # TODO: switch to "eu-west-1" once CloudMargin account is available
    key     = "terraform.tfstate"
    bucket  = "alx-cloudmargin-tfstate"
    dynamodb_table = "alx-cloudmargin-locks"
    encrypt        = true
  }
}

provider "aws" {
  profile = "cloudmargin"
  region  = "us-east-1" # TODO: switch to "eu-west-1" once CloudMargin account is available
  assume_role {
    # 692640583927 is a private AWS account - needs to be switched to the CloudMargin
    # account (623654405055).
    role_arn = "arn:aws:iam::692640583927:role/alx-cloudmargin-robot-role"
  }
}

module "vpc" {
  source             = "./vpc"
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

# wire up the VPCs created above to the security groups below 
module "security_groups" {
  source         = "./security-groups"
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}