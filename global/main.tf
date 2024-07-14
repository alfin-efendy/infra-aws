locals {
  s3_types = ["public", "private"]
}

resource "aws_kms_key" "state_backend_kms_key" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}
# create state-files S3 buket 
resource "aws_s3_bucket" "state_backend_bucket" {
  for_each = flatten([for type in local.s3_types : [
    for env in var.environments : [
      "${type}-${env}"
    ]
  ]])

  bucket = "${var.project_name}-${each.value}"
  # to drop a bucket, set to `true`
  force_destroy = false
  lifecycle {
    # to drop a bucket, set to `false`
    prevent_destroy = true
  }
  tags = {
    type = split("-", each.value)[0]
    environment = split("-", each.value)[1]
  }
}

# enable S3 bucket versioning
resource "aws_s3_bucket_versioning" "state_backend_versioning" {
  for_each = aws_s3_bucket.state_backend_bucket
  bucket   = each.value.id
  versioning_configuration {
    status = "Enabled"
  }
}

# enable S3 bucket encryption per each Env's bucket
resource "aws_s3_bucket_server_side_encryption_configuration" "state_backend_bucket_encryption" {
  bucket = aws_s3_bucket.state_backend_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.state_backend_bucket_kms_key.arn
      sse_algorithm     = "aws:kms"
    }
    bucket_key_enabled = true
  }
}

# block S3 bucket public access per each Env's bucket
resource "aws_s3_bucket_public_access_block" "state_backend_bucket_acl" {
  bucket                  = aws_s3_bucket.state_backend_bucket.id
  
  block_public_acls       = aws_s3_bucket.state_backend_bucket.tags["type"] == "private" ? true : false
  block_public_policy     = aws_s3_bucket.state_backend_bucket.tags["type"] == "private" ? true : false
  ignore_public_acls      = aws_s3_bucket.state_backend_bucket.tags["type"] == "private" ? true : false
  restrict_public_buckets = aws_s3_bucket.state_backend_bucket.tags["type"] == "private" ? true : false
}
