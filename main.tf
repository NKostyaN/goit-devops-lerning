# Підключаємо модуль S3 та DynamoDB
module "s3_backend" {
  source      = "./modules/s3-backend"
  bucket_name = "goit-lern-nkos-terraform-bucket"
  table_name  = "goit-lern-nkos-terraform-locks"
}

# Підключаємо модуль VPC
module "vpc" {
  source             = "./modules/vpc"
  vpc_cidr_block     = "10.0.0.0/16"
  public_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets    = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  availability_zones = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  vpc_name           = "goit-lern-nkos-lesson-db-module"
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "goit-lern-nkos-lesson-db-module-ecr"
  scan_on_push = true
}

# Підключаємо модуль EKS
module "eks" {
  source          = "./modules/eks"
  cluster_name    = var.cluster_name
  subnet_ids      = module.vpc.public_subnets
  instance_type   = "t3.medium"
  desired_size    = 2
  max_size        = 3
  min_size        = 1
}

# Підключаємо модуль Jenkins
module "jenkins" {
  source    = "./modules/jenkins"
  namespace = "jenkins"
  cluster_name = var.cluster_name
  github_username = var.github_username
  github_token    = var.github_token
  github_repo     = var.github_repo
  oidc_provider_arn = module.eks.oidc_provider_arn
  oidc_provider_url = module.eks.oidc_provider_url
  
  depends_on = [module.eks]
}

# Підключаємо модуль Argo CD
module "argo_cd" {
  source    = "./modules/argo_cd"
  namespace = "argocd"
  github_username = var.github_username
  github_token    = var.github_token
  github_repo     = var.github_repo
  path_to_charts  = "charts/django-app"

  depends_on = [module.eks]
}

# Підключаємо модуль RDS
module "rds" {
  source = "./modules/rds"

  name                       = "myapp-db"
  use_aurora                 = false
  aurora_instance_count      = 2
  
  # --- Aurora-only ---
  engine_cluster             = "aurora-postgresql"
  engine_version_cluster     = "15.8"
  parameter_group_family_aurora = "aurora-postgresql15"
  
  # --- RDS-only ---
  engine                     = "postgres"
  engine_version             = "17.2"
  parameter_group_family_rds = "postgres17"
  
  # Common
  instance_class             = "db.t3.medium"
  allocated_storage          = 20
  db_name                    = "myapp"
  username                   = "postgres"
  password                   = "admin123AWS23"
  subnet_private_ids         = module.vpc.private_subnets
  subnet_public_ids          = module.vpc.public_subnets
  publicly_accessible        = true
  vpc_id                     = module.vpc.vpc_id
  multi_az                   = true
  backup_retention_period    = 7
  parameters = {
    max_connections              = "200"
    log_min_duration_statement   = "500"
  }

  tags = {
    Environment = "dev"
    Project     = "myapp"
  }
}

data "aws_eks_cluster_auth" "eks" {
  name = module.eks.eks_cluster_name
}

provider "helm" {
  kubernetes {
    host                   = module.eks.eks_cluster_endpoint
    cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
    token                  = data.aws_eks_cluster_auth.eks.token
  }
}

provider "kubernetes" {
  host                   = module.eks.eks_cluster_endpoint
  cluster_ca_certificate = base64decode(module.eks.cluster_certificate_authority_data)
  token                  = data.aws_eks_cluster_auth.eks.token
}
