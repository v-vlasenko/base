resource "aws_s3_bucket" "movable" {}

output "movable_tags_all" { value = aws_s3_bucket.movable.tags_all }
