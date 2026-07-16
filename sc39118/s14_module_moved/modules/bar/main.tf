variable "suffix" {
  type = string
}

resource "aws_s3_bucket" "b" {
  bucket = "sc39118-s14-${var.suffix}"
}
