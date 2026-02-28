# terraform {
#   backend "s3" {
#     bucket         = "goti-lern-nkos-terraform-bucket"
#     key            = "final-project/terraform.tfstate"
#     region         = "eu-west-1"
#     dynamodb_table = "goit-lern-nkos-terraform-locks"
#     encrypt        = true
#   }
# }
