terraform {
  source = "tfr://registry.terraform.io/cloudposse/label/null?version=0.25.0"
}
inputs = {
  namespace = "eg"
  stage     = "prod"
  name      = "app"
}

generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<EOF
terraform {
  backend "remote" {
    hostname     = "mainiacp.stack.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces {
      name = "extbe-1788439157-s26-reg"
    }
  }
}
EOF
}
