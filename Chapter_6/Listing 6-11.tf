provider "aws" {
    region = "us-east-1"
}

resource "aws_codecommit_repository" "test" {
  repository_name = "devops-ios-repository"
  description     = "Example Description"
}
