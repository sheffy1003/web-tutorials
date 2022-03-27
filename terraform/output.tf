
output "bucket_url" {
  value = [
    aws_s3_bucket.s3Bucket.website_domain,
    aws_s3_bucket.s3Bucket.website_endpoint,
    aws_s3_bucket.s3Bucket.website
  ]
}