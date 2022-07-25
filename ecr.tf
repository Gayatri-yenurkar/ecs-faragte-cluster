resource "aws_ecr_repository" "repo" {
  name = "ecr-repo"

  image_scanning_configuration {
    scan_on_push = true
  }
}