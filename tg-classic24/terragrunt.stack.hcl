# Present so the CV is a genuine stack CV (has_terragrunt_stack=true).
# With run-all disabled the classic pipeline must ignore this file.
unit "u" {
  source = "./units/u"
  path   = "u"
}
