resource "aws_cloudwatch_log_group" "shared" {
  name = "qa39371-tg-shared"
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.shared.name
}
