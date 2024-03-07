output "host_bucket_regional_domain_name" {
  value = aws_s3_bucket.bucket.bucket_regional_domain_name
}

output "s3_origin" {
  value = aws_s3_bucket.bucket.id
}
output "log_bucket_id" {
  value = aws_s3_bucket.log_bucket[0].id
}
output "log_bucket_domain" {
  value = aws_s3_bucket.log_bucket[0].bucket_regional_domain_name
}