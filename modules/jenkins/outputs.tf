output "jenkins_release_name" {
  description = "Jenkins release name"
  value = helm_release.jenkins.name
}

output "jenkins_namespace" {
  description = "Jenkins namespace"
  value = helm_release.jenkins.namespace
}

output "jenkins_password" {
  description = "To get Jenkins initial admin password"
  value       = "kubectl exec -n jenkins -it svc/jenkins -c jenkins -- /bin/cat /run/secrets/additional/chart-admin-password && echo"
}