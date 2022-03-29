
terraform {
  backend "s3" {
    bucket         = "tutorialstatebuck"
    key            = "ci/testing/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "statelock-tutorial"
    encrypt        = true
  }
}

terraform {
  required_version = ">= 0.12"
}

provider "aws" {
  region = "us-east-1"
}

// static website bucket

resource "aws_s3_bucket" "bk" {
  bucket = var.BUCKET
  tags = {
    "env" = "sandbox"
  }
}

resource "aws_s3_bucket_acl" "cl" {
  bucket = aws_s3_bucket.bk.id
  acl    = "public-read"
}

resource "aws_s3_bucket_policy" "py" {
  bucket = aws_s3_bucket.bk.id
  policy = data.aws_iam_policy_document.public.json
}

resource "aws_s3_bucket_website_configuration" "wb" {
  bucket = aws_s3_bucket.bk.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}
// Public policy

data "aws_iam_policy_document" "public" {
  statement {
    sid = "MakePublic"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${var.BUCKET}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

