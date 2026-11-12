generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOT
terraform {
  backend "http" {
    address = "https://checkov.testenv.scalr.dev/api/iacp/v3/qa39371-no-state/${path_relative_to_include()}"
  }
}
EOT
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite"
  contents  = <<EOT
provider "aws" {
  region                      = "us-east-1"
  access_key                  = "mock"
  secret_key                  = "mock"
  skip_credentials_validation = true
  skip_requesting_account_id  = true
  skip_metadata_api_check     = true
}
EOT
}
