variable "bucket_name"{
  type = string
}

variable "bucket_acl_permission" {
  type = string
  description = "possible values: READ, WRITE, READ_ACP, WRITE_ACP, FULL_CONTROL"
  default = "FULL_CONTROL"
}

variable "bucket_ownership_control" {
  default = "BucketOwnerPreferred"
  description = "possible values: BucketOwnerPreferred, ObjectWriter, BucketOwnerEnforced"
  type = string
}

variable "distro_id" {
  type = string
}

variable "enable_bucket_logs" {
  default = true
  type = bool
}
variable "environment" {
  default = "dev"
  type = string
}

variable "s3_force_destroy" {
  type = bool
  default = false
}