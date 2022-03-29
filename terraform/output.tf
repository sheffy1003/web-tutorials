
output "bucket_url" {
  value = [
    aws_s3_bucket.bk.website_domain,
    aws_s3_bucket.bk.website_endpoint,
    aws_s3_bucket.bk.website
  ]
}
