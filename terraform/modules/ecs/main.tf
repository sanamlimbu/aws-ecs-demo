resource "aws_ecs_cluster" "main" {
  name = var.name
}

resource "aws_security_group" "ecs_tasks_sg" {
  name_prefix = "${var.name}-ecs-tasks-sg-${var.env}"
  vpc_id      = var.vpc_id
  description = "Allow ALB to reach ECS tasks"
}

resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb_http" {
  security_group_id            = aws_security_group.ecs_tasks_sg.id
  referenced_security_group_id = var.alb_sg_id
  from_port                    = 8080
  to_port                      = 8080
  ip_protocol                  = "tcp"
  description                  = "Allow ALB to reach ECS tasks on HTTP"
}

resource "aws_vpc_security_group_egress_rule" "ecs_all_out" {
  security_group_id = aws_security_group.ecs_tasks_sg.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1"
  description       = "Allow all outbound traffic"
}