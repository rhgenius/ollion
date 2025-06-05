# CodeCommit Repository
resource "aws_codecommit_repository" "app_repo" {
  repository_name = var.repository_name
  description     = "Application source code repository"

  tags = {
    Name        = var.repository_name
    Environment = var.environment
  }
}

# IAM role for CodeCommit access
resource "aws_iam_role" "codecommit_access" {
  name = "${var.project_name}-codecommit-access-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codecommit.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name        = "${var.project_name}-codecommit-access-role"
    Environment = var.environment
  }
}

# IAM policy for CodeCommit access
resource "aws_iam_policy" "codecommit_access" {
  name        = "${var.project_name}-codecommit-access-policy"
  description = "Policy for CodeCommit access"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "codecommit:GitPull",
          "codecommit:GitPush",
          "codecommit:CreateBranch",
          "codecommit:DeleteBranch",
          "codecommit:GetBranch",
          "codecommit:ListBranches",
          "codecommit:MergeBranchesByFastForward",
          "codecommit:MergeBranchesBySquash",
          "codecommit:MergeBranchesByThreeWay",
          "codecommit:GetMergeCommit",
          "codecommit:GetMergeConflicts",
          "codecommit:GetMergeOptions",
          "codecommit:GetRepository"
        ]
        Effect   = "Allow"
        Resource = aws_codecommit_repository.app_repo.arn
      }
    ]
  })
}

# Attach policy to CodeCommit role
resource "aws_iam_role_policy_attachment" "codecommit_access_attachment" {
  role       = aws_iam_role.codecommit_access.name
  policy_arn = aws_iam_policy.codecommit_access.arn
}