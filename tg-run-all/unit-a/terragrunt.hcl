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
    key            = "tg-run-all/unit-a/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "scalr-tg-test-locks"
  }
}