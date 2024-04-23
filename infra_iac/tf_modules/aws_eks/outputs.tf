output "cluster_name" {
  description = "The name/id of the EKS cluster. Will block on cluster creation until the cluster is really ready."
  value       = module.eks.cluster_name
}

output "cluster_version" {
  description = "The Kubernetes server version for the EKS cluster."
  value       = module.eks.cluster_version
}

# ECR variables
output "ecr_repository_url" {
  description = "The URL of the ECR repository"
  value = aws_ecr_repository.ecr.repository_url
}
