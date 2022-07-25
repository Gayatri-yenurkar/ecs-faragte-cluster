
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/myapp"
  
}

resource "aws_cloudwatch_log_stream" "app_log_stream" {
  name           = "my-log-stream"
  log_group_name = aws_cloudwatch_log_group.app_log_group.name
}