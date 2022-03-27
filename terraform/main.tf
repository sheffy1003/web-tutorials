
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

  policy = <<EOF
  {
     "id" : "MakePublic",
   "version" : "2012-10-17",
   "statement" : [
      {
         "action" : [
             "s3:GetObject"
          ],
         "effect" : "Allow",
         "resource" : "arn:aws:s3:::${var.BUCKET}/*",
         "principal" : "*"
      }
    ]
  }
  EOF

  website {
    index_document = "index.html"
  }
}