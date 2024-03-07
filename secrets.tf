
resource "aws_ssm_parameter" "s3" {
  name  = "/RFDEV/S3_BUCKET"
  type  = "SecureString"
  value = module.s3.s3_origin
}

resource "aws_ssm_parameter" "CF" {
  name  = "/RFDEV/CF_DISTRO"
  type  = "SecureString"
  value = module.cloudfront.distro_id
}

resource "aws_ssm_parameter" "role" {
  name  = "/RFDEV/IAM_ROLE_ARN"
  type  = "SecureString"
  value = aws_iam_role.ghactions.arn
}


