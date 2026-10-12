run "hcl_provider_arguments" {
  command = plan

  assert {
    condition     = aws_s3_bucket.example.tags_all["T1"] == "dev"
    error_message = "T1 is ${aws_s3_bucket.example.tags_all["T1"]}"
  }

  assert {
    condition     = aws_s3_bucket.example.tags_all["T2"] == "hello-dev"
    error_message = "T2 is ${aws_s3_bucket.example.tags_all["T2"]}"
  }
}
