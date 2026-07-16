variable "suffix" {
  type = string
}

resource "aws_s3_bucket" "old" {
  bucket = "sc39118-s12-${var.suffix}"
}

output "bucket_id" {
  value = aws_s3_bucket.old.id
}
