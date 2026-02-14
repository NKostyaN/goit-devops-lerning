data "aws_caller_identity" "current" {} #Отримуємо ID поточного акаунту автоматично

resource "aws_ecr_repository" "this" {
  name = var.ecr_name

  image_scanning_configuration {
    scan_on_push = var.scan_on_push     #вмикаємо автоматичне сканування образів
  }

  tags = {
    Name = var.ecr_name
  }
}

data "aws_iam_policy_document" "ecr_repo_policy" {
  statement {
    sid = "AllowAccountAccess"

    principals {
      type = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.current.account_id}:root"]
    }

    actions = [
      "ecr:GetDownloadUrlForLayer",
      "ecr:BatchGetImage",
      "ecr:ListImages"
    ]
  }
}


# data "aws_iam_policy_document" "ecr_repo_policy" {
#   statement {
#     sid = "AllowPullAll"
#     principals {
#       type = "AWS"
#       identifiers = ["*"]
#     }
#     actions = [
#       "ecr:GetDownloadUrlForLayer",
#       "ecr:BatchGetImage",
#       "ecr:ListImages"
#     ]
#     resources = [
#       aws_ecr_repository.this.arn
#     ]
#   }
# }

# Налаштування політики доступу до репозиторію
resource "aws_ecr_repository_policy" "this" {
  repository = aws_ecr_repository.this.name
  policy = data.aws_iam_policy_document.ecr_repo_policy.json
}