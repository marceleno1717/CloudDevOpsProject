variable "ecr_repos" {
  type = list(string)
}

variable "cluster_name" {
  type    = string
  default = "main-eks"
}
