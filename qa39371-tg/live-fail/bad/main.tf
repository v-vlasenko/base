resource "aws_cloudwatch_log_group" "bad" {
  name              = "qa39371-tg-fail-bad"
  retention_in_days = 7
  kms_key_id        = var.missing
}
