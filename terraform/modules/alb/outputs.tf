output "alb_sg_id" {
  value = aws_security_group.alb_sg.id
}

output "http_listener_arn" {
  value = aws_lb_listener.http.arn
}

