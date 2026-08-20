resource "aws_s3_bucket" "movable" {
  count = 1
}

moved {
  from = aws_s3_bucket.movable
  to   = aws_s3_bucket.movable[0]
}

output "movable_tags_all" { value = aws_s3_bucket.movable[*].tags_all }
