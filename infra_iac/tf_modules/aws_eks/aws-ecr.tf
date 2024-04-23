resource "aws_ecr_repository" "ecr" {
  name                 = var.ecr_name
  encryption_configuration {
    encryption_type = "AES256"
  }

  tags = {
    terraform = "true"
    env       = var.env
    group     = var.group
    app       = var.app
  }
}
