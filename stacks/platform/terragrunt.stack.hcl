unit "monitoring" {
  source = "git::https://github.com/v-vlasenko/base.git//catalog/monitoring?ref=tg-stack-vcs"
  path   = "monitoring"
}

unit "logging" {
  source = "git::https://github.com/v-vlasenko/base.git//catalog/logging?ref=tg-stack-vcs"
  path   = "logging"
}
