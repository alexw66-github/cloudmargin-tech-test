# using a private AWS account for now, as I don't seem to have access to anything
# on CloudMargin. Probably me...

provider "aws" {
  region  = "us-east-1"
  profile = "cloudmargin"
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = "alx-cloudmargin-tfstate"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.terraform_state.bucket

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.terraform_state.bucket

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "alx-cloudmargin-locks"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}

resource "aws_iam_policy" "robot_policy" {
  name   = "alx-cloudmargin-robot-policy"
  policy = data.aws_iam_policy_document.robot_policy.json
}

data "aws_iam_policy_document" "robot_policy" {
  statement {
    effect = "Allow"
    actions = [
      "*"
    ]
    resources = [
      "*"
    ]
  }
}

resource "aws_iam_role" "robot_role" {
  name                = "alx-cloudmargin-robot-role"
  assume_role_policy  = data.aws_iam_policy_document.robot_role.json
  managed_policy_arns = [aws_iam_policy.robot_policy.arn]
}

data "aws_iam_policy_document" "robot_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
