# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goti-lern-nkos-terraform-bucket"
  table_name  = "goit-lern-nkos-terraform-locks"
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_name           = "goit-lern-nkos-lesson-5-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "goit-lern-nkos-lesson-5-ecr"
  scan_on_push = true
}

# Підключаємо модуль EKS
module "eks" {
  source          = "./modules/eks"
  cluster_name    = "goit-lern-nkos-cluster"
  subnet_ids      = module.vpc.public_subnets
  instance_type   = "t2.micro"
  desired_size    = 2
  max_size        = 2
  min_size        = 1
}