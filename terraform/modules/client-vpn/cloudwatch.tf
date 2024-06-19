resource "aws_cloudwatch_log_group" "_" {
  name = "${var.name}-client-vpn"
}

resource "aws_cloudwatch_log_stream" "_" {
  name           = "Connection_Log"
  log_group_name = aws_cloudwatch_log_group._.name
} 