terraform {
  source = "."
}

remote_state {
  backend = "s3"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    bucket         = "scalr-tg-test-state"
    key            = "tg-run-all-no-export/unit-b/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "scalr-tg-test-locks"
    access_key     = get_env("S3_ACCESS_KEY")
    secret_key     = get_env("S3_SECRET_KEY")
  }
}
