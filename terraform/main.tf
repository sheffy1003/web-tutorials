
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
  for_each = var.config
  bucket   = each.value.bucket #var.bucket
  tags = {
    "env" = each.key
  }
}

resource "aws_s3_bucket_acl" "cl" {
  for_each = var.config
  bucket   = aws_s3_bucket.bk[each.key].id
  acl      = each.value.acl #"public-read"
}

resource "aws_s3_bucket_policy" "py" {
  for_each = var.config
  bucket   = aws_s3_bucket.bk[each.key].id # aws_s3_bucket.bk.id
  policy   = data.aws_iam_policy_document.public[each.key].json
}

resource "aws_s3_bucket_website_configuration" "wb" {
  for_each = var.config
  bucket   = aws_s3_bucket.bk[each.key].id #aws_s3_bucket.bk.id

  index_document {
    suffix = each.value.web.index_document #"index.html"
  }

  error_document {
    key = each.value.web.error_document #"error.html"
  }
}
// Public policy

data "aws_iam_policy_document" "public" {
  for_each = var.config
  statement {
    sid = "MakePublic"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "arn:aws:s3:::${each.value.bucket}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

