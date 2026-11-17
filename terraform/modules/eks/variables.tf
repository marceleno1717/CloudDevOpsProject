variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version for the EKS cluster"
  type        = string
  default     = "1.35"
}

variable "private_subnet_ids" {
  description = "Map of AZ key to private subnet ID where worker nodes will be placed (one node group per subnet/AZ)"
  type        = map(string)
}

variable "instance_types" {
  description = "EC2 instance types for the worker nodes"
  type        = list(string)
  default     = ["t3.small"]
}

variable "ami_type" {
  description = "AMI type for the EKS node groups"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "capacity_type" {
  description = "Capacity type for the EKS node groups (ON_DEMAND or SPOT)"
  type        = string
  default     = "ON_DEMAND"
}

variable "disk_size" {
  description = "Root EBS volume size (GiB) for each worker node"
  type        = number
  default     = 20
}

variable "node_desired_size" {
  description = "Desired number of worker nodes per private subnet / AZ"
  type        = number
  default     = 1
}

variable "node_min_size" {
  description = "Minimum number of worker nodes per private subnet / AZ"
  type        = number
  default     = 1
}

variable "node_max_size" {
  description = "Maximum number of worker nodes per private subnet / AZ"
  type        = number
  default     = 2
}
