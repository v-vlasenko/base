variable "prefix" {
  type = string
}

variable "shared_log_group" {
  type = string
}

variable "db_password" {
  type      = string
  sensitive = true
  default   = "qa39371-TG-SECRET-value"
}

resource "aws_cloudwatch_log_group" "app" {
  name = "${var.prefix}-app-${var.shared_log_group}"
}

resource "aws_ssm_parameter" "db_password" {
  name  = "/${var.prefix}/db-password"
  type  = "String"
  value = var.db_password
}
