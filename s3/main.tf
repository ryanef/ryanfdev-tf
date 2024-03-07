resource "aws_s3_bucket" "bucket" {
  
  bucket = var.bucket_name
  force_destroy = var.s3_force_destroy
  tags = {
    Name        = var.environment
    Environment = var.environment
  }
}

resource "aws_s3_bucket_policy" "main" {
  bucket = aws_s3_bucket.bucket.id
  policy = data.aws_iam_policy_document.s3_oac.json
}


resource "aws_s3_bucket" "log_bucket" {
  count = var.enable_bucket_logs ? 1 : 0
  bucket = "${var.bucket_name}-logs"
  force_destroy = var.s3_force_destroy
  tags = {
    Name        = var.environment
  }
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.log_bucket[0].id
  policy = data.aws_iam_policy_document.logger.json
}

resource "aws_s3_bucket_ownership_controls" "acl" {
    count = var.enable_bucket_logs ? 1 : 0
  bucket = aws_s3_bucket.log_bucket[0].id
  rule {
    object_ownership = var.bucket_ownership_control
  }
}

resource "aws_s3_bucket_acl" "acl" {
  count = var.enable_bucket_logs ? 1 : 0
  depends_on = [aws_s3_bucket_ownership_controls.acl]
  bucket = aws_s3_bucket.log_bucket[0].id

  access_control_policy {
    grant {
      grantee {
        id = data.aws_canonical_user_id.this.id
        type = "CanonicalUser"
      }
      permission = var.bucket_acl_permission
    }
    owner {
      id = data.aws_canonical_user_id.this.id
    }
  }
}
