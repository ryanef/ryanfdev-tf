module "cloudfront" {
  source = "./cloudfront"

  acm_arn = aws_acm_certificate.cert.arn

  cf_aliases = ["ryanf.dev", "www.ryanf.dev"]
  distro_name = "ryanfdev"
  
  s3_site = "ryanfdev"
  s3_origin = module.s3.s3_origin
  bucket_regional_domain_name = module.s3.host_bucket_regional_domain_name
  log_bucket_domain = module.s3.log_bucket_domain

}

module "s3" {
  source = "./s3"

  bucket_name = "ryanfdev-admin"
  distro_id = module.cloudfront.distro_id
}