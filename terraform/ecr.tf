resource "aws_ecr_repository" "ecr" {
  name = var.aws_ecr_repository_name
}