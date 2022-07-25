#ecs-cluster creation


resource "aws_ecs_cluster" "demo-ecs" {
  name = "app-cluster"
}

data "template_file" "myapp" {
  template = file("./templates/ecs/myapp.json.tpl")

  vars = {
    app_image      = var.app_image
    app_port       = var.app_port
    fargate_cpu    = var.fargate_cpu
    fargate_memory = var.fargate_memory
    aws-region     = var.aws-region


  }

}

resource "aws_ecs_task_definition" "ecs-task" {

  family                   = "myapp-task"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.fargate_cpu
  memory                   = var.fargate_memory
  container_definitions    = data.template_file.myapp.rendered
}
resource "aws_ecs_service" "demo-ecs" {
  name            = "ecs-fargate"
  cluster         = aws_ecs_cluster.demo-ecs.id
  task_definition = aws_ecs_task_definition.ecs-task.arn
  desired_count   = var.app_count
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks.id]
    subnets          =  aws_subnet.ecs-subnet.*.id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs-tg.id
    container_name   = "myapp"
    container_port   = var.app_port
  }

  depends_on = [aws_alb_listener.http-listener, aws_iam_role_policy_attachment.ecs_task_execution_role]


}