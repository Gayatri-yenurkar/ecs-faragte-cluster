variable "aws-region" {
  description = "AWS"
  default     = "us-east-1"
}
variable "access-key" {
  default =""
}
variable "secret-key" {
  default = ""
}
variable "app_image" {
  description = "Docker image to run in ECS cluster"
  default     = "nginx:latest"
}
variable "app_port" {
  description = "port exposed by docker to direct traffic"
  default     = "80"

}
variable "fargate_cpu" {
  description = "Fargate instance CPU unit"
  default     = "1024"

}
variable "fargate_memory" {

  description = "Fargate instance memory"
  default     = "2048"

}
variable "ecs_task_execution_role_name" {
  default = "ecs-task-execution-role"

}
variable "az_count" {
  description = "No of AZ in a region"
  default     = "2"
}

variable "aws_vpc_cidr" {
  description = "The CIDR of the main vpc"
  default = "170.10.0.0/16"
}
variable "app_count" {
  description = "Number of docker containers to run"
  default     = 1
}
