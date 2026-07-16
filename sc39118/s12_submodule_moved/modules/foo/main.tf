variable "suffix" {
  type = string
}

resource "aws_s3_bucket" "new" {
  bucket = "sc39118-s12-${var.suffix}"
}

moved {
  from = aws_s3_bucket.old
  to   = aws_s3_bucket.new
}

output "bucket_id" {
  value = aws_s3_bucket.new.id
}
