generate "backend" {
  path      = "backend.tf"
  if_exists = "overwrite"
  contents  = <<-EOT
    terraform {
      backend "remote" {
        hostname     = "${get_env("SCALR_HOSTNAME")}"
        organization = "env-v0pg6d0c7m3csd8gj"
        token        = "${get_env("SCALR_TOKEN")}"
        workspaces {
          name = "qa37302-tgstate-${basename(get_terragrunt_dir())}"
        }
      }
    }
  EOT
}
