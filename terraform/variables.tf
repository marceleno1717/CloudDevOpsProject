variable "ecr_repos" {
  type = list(string)
}

variable "cluster_name" {
  type    = string
  default = "main-eks"
}

variable "min_node_size" {
  type    = number
  default = 1
}
