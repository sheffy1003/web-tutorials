
terraform {
  backend "s3" {
    bucket         = "tutorialstatebuck"
    key            = "terraform.tfstate"
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

resource "aws_s3_bucket" "s3Bucket" {
  bucket = var.BUCKET
  acl    = "public-read"

  policy = data.aws_iam_policy_document.public.json

  website {
    index_document = "index.html"
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