terraform {
  source = "git::https://github.com/cloudposse/terraform-null-label.git//.?ref=0.25.0"
}
inputs = {
  namespace = "eg"
  stage     = "prod"
  name      = "app"
}
