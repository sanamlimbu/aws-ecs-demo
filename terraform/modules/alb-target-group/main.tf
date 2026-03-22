resource "aws_lb_target_group" "main" {
  name        = var.name
  vpc_id      = var.vpc_id
  protocol    = "HTTP"
  port        = 8080
  target_type = "ip"

  health_check {
    path                = var.health_check_path
    interval            = 30
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 2
    matcher             = "200"
  }
}