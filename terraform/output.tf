
output "bucket_url" {
  value = [
    values(aws_s3_bucket.bk)[*].website
  ]
}
