variable "tf_var" {
  description = "Test: terraform var from set"
  default     = "not_set"
}

variable "var1" {
  description = "Test: precedence chain"
  default     = "not_set"
}

variable "hcl_var" {
  description = "Test: HCL evaluated var from set"
  default     = "not_set"
}

variable "final_var" {
  description = "Test: final flag var from set"
  default     = "not_set"
}

variable "sens_var" {
  description = "Test: sensitive var from set"
  sensitive   = true
  default     = "not_set"
}

variable "cascade_var" {
  description = "Test: var from cascade set"
  default     = "not_set"
}

variable "unlink_var" {
  description = "Test: var from unlink set"
  default     = "not_set"
}

variable "shared_key" {
  description = "Test: shared key across 20 sets - alphabetical winner should be bulk-set-01"
  default     = "not_set"
}

output "tf_var_value"      { value = var.tf_var }
output "var1_value"        { value = var.var1 }
output "hcl_var_value"     { value = var.hcl_var }
output "final_var_value"   { value = var.final_var }
output "cascade_var_value" { value = var.cascade_var }
output "unlink_var_value"  { value = var.unlink_var }
output "shared_key_value"  { value = var.shared_key }

resource "terraform_data" "this" {
  triggers_replace = timestamp()
}
