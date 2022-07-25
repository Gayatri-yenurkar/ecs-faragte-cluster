resource "aws_alb" "ecs-alb" {
  name               = "alb"
  subnets            = aws_subnet.ecs-subnet.*.id
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb.id]
}

resource "aws_alb_listener" "http-listener" {
  load_balancer_arn = aws_alb.ecs-alb.id
  port              = var.app_port
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.ecs-tg.id
  }
}

resource "aws_alb_target_group" "ecs-tg" {
  name        = "ecs-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.ecs-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "30"
    protocol            = "HTTP"
    matcher             = "200"
    timeout             = "10"
    path                = "/"
    unhealthy_threshold = "2"
  }
}