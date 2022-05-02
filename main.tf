terraform {
  # pinning to the latest version of Terraform
  required_version = ">= 0.14"
  backend "s3" {
    profile = "cloudmargin"
    region  = "us-east-1" # switch to "eu-west-1" once CloudMargin account is available
    key     = "terraform.tfstate"
    bucket  = "alx-cloudmargin-tfstate"
    dynamodb_table = "alx-cloudmargin-locks"
    encrypt        = true
  }
}

provider "aws" {
  profile = "dev"
  region  = "us-east-1"
  assume_role {
    # this is a private AWS account - it will need to be switched to the CloudMargin
    # account (623654405055).
    role_arn = "arn:aws:iam::692640583927:role/alx-cloudmargin-robot-role"
  }
}
