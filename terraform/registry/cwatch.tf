resource "aws_cloudwatch_log_group" "current" {
  name = "${var.service_name}-ecs"
}