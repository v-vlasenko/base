terraform {
  required_version = ">= 1.0"
}

module "sha_ref" {
  source = "git::https://github.com/v-vlasenko/checkov-private-module.git//modules/example?ref=4ac3a20fa881ecd8b295fc72fdb9bce2cd5f831e"
  name   = "sha-ref"
}