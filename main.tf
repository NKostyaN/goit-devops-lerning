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
  vpc_name           = "goit-lern-nkos-lesson-8-9-vpc"
}

# Підключаємо модуль ECR
module "ecr" {
  source       = "./modules/ecr"
  ecr_name     = "goit-lern-nkos-lesson-8-9-ecr"
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
  # ecr_repository_url = module.ecr.repository_url
  
  depends_on = [module.eks]
}

# Підключаємо модуль Argo CD
module "argo_cd" {
  source    = "./modules/argo_cd"
  namespace = "argocd"
  github_username = var.github_username
  github_token    = var.github_token
  github_repo     = var.github_repo
  # target_revision = "lesson-7"
  path_to_charts  = "charts/django-app"

  depends_on = [module.eks]
}
