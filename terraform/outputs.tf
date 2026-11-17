output "ecr_urls" {
  value = module.ecrs[*].ecr_repo_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}
