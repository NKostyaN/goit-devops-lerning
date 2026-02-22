output "s3_bucket_name" {
  description = "Назва S3-бакета для стейтів"
  value       = module.s3_backend.s3_bucket_name
}

output "dynamodb_table_name" {
  description = "Назва таблиці DynamoDB для блокування стейтів"
  value       = module.s3_backend.dynamodb_table_name
}

output "vpc_id" {
  description = "ID створеної VPC"
  value       = module.vpc.vpc_id
}


output "ecr_repository_url" {
  description = "URL ECR-репозиторію"
  value       = module.ecr.repository_url
}

output "update-kubeconfig" {
  description = "Update Kubernetes configuration"
  value       = "aws eks update-kubeconfig --region eu-west-1 --name goit-lern-nkos-cluster"
}

output "get-jenkins-link" {
  description = "Get Jenkins Link"
  value       = "kubectl get svc -n jenkins"
}

output "get-argocd-link" {
  description = "Get Argo CD Link"
  value       = "kubectl get svc -n argocd"
}

output "argo_cd_server_service" {
  description = "Argo CD server service"
  value       = module.argo_cd.argo_cd_server_service
}

output "admin_password" {
  description = "Initial admin password for Argo CD"
  value       = module.argo_cd.admin_password
}
