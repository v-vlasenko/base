terraform {
  source = "tfr://registry.terraform.io/cloudposse/label/null?version=0.25.0"
}
inputs = {
  namespace = "eg"
  stage     = "prod"
  name      = "app"
}
