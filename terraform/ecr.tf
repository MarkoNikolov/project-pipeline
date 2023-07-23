resource "aws_ecr_repository" "ecr" {
  name = var.aws_ecr_repository_name
}

resource "aws_ecr_lifecycle_policy" "ecr_policy" {
  repository = aws_ecr_repository.ecr.name

  policy = jsonencode({
    rules = [
      {
        "rulePriority"    : 10,
        "description"     : "Expire old images",
        "selection"       : {
          "tagStatus"        : "tagged",
          "countType"        : "imageCountMoreThan",
          "countNumber"      : 10,
          "countUnit"        : "image"
        },
        "action"          : {
          "type"             : "expire"
        }
      }
    ]
  })
}