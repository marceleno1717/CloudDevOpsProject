output "ecr_urls" {
  value = module.ecrs[*].ecr_repo_url
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "github_actions_role_arn" {
  value = aws_iam_role.github_actions_ecr.arn
}
