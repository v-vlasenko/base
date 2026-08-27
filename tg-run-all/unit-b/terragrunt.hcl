terraform {
  source = "."
}

remote_state {
  backend = "remote"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    hostname     = "mainiacp.agent-test.testenv.scalr.dev"
    organization = "tfenv1"
    workspaces = {
      name = "s39803-tg-state-b"
    }
  }
}
