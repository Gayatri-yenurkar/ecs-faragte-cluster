#ALB Security group

resource "aws_security_group" "lb" {

  name   = "myapp-lb-sg"
  vpc_id = aws_vpc.ecs-vpc.id

  ingress {
    protocol    = "tcp"
    from_port   = var.app_port
    to_port     = var.app_port
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Traffic to ECS cluster should only come from ALB
resource "aws_security_group" "ecs_tasks" {
  name        = "myapp-ecs-tasks-sg"
  description = "allow inbound access from the ALB only"
  vpc_id      = aws_vpc.ecs-vpc.id
  ingress {
    protocol        = "tcp"
    from_port       = var.app_port
    to_port         = var.app_port
    cidr_blocks     = ["0.0.0.0/0"]
    security_groups = [aws_security_group.lb.id]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}