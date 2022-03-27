
terraform {
  backend "s3" {
    bucket         = "stackbuckstate-sheff"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "statelock-tf"
  }
}


terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      Version = "~>3.27"
    }
  }

  required_version = ">=0.14.9"

}

provider "aws" {
  version = "~>3.0"
  region  = "east-us-1"
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