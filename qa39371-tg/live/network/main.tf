resource "aws_cloudwatch_log_group" "network" {
  name = "qa39371-tg-network"
}

output "prefix" {
  value = "qa39371-tg"
}
