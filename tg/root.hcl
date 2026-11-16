remote_state {
  backend = "remote"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }
  config = {
    hostname     = get_env("SCALR_HOSTNAME")
    organization = "env-v0pg6d0c7m3csd8gj"
    token        = get_env("SCALR_TOKEN")
    workspaces = {
      name = "qa37302-tgstate-${basename(path_relative_to_include())}"
    }
  }
}
