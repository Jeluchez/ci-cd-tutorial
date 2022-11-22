resource "aws_lb_target_group" "my_app" {
  name        = "${var.service_name}-tg"
  port        = 80
  protocol    = "HTTP"
  target_type = "ip"
  vpc_id      = aws_vpc.main.id
  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }
}

resource "aws_lb" "my_app" {
  name               = "myApp"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id, aws_security_group.https.id]
  subnets            = [aws_subnet.public1.id, aws_subnet.public2.id]
  enable_deletion_protection = false
}
resource "aws_lb_listener" "my_app_http" {
  load_balancer_arn = aws_lb.my_app.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.my_app.arn
  }
}
output "lb_url" {
  value = "http://${aws_lb.my_app.dns_name}"
}
