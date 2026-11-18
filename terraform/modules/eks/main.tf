resource "aws_eks_cluster" "this" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = values(var.private_subnet_ids)
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]
}

# One managed node group per private subnet/AZ guarantees worker nodes are
# distributed across distinct private subnets and Availability Zones.
resource "aws_eks_node_group" "nodes" {
  for_each = var.private_subnet_ids

  cluster_name    = aws_eks_cluster.this.name
  node_group_name = "${var.cluster_name}-node-group-${each.key}"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = [each.value]

  ami_type       = var.ami_type
  capacity_type  = var.capacity_type
  instance_types = var.instance_types
  disk_size      = var.disk_size

  scaling_config {
    desired_size = var.node_desired_size
    min_size     = var.node_min_size
    max_size     = var.node_max_size
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.eks_ecr_readonly,
  ]
}

resource "aws_eks_addon" "pod_identity_agent" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "eks-pod-identity-agent"

  depends_on = [
    aws_eks_node_group.nodes,
  ]
}

resource "aws_eks_pod_identity_association" "ebs_csi" {
  cluster_name    = aws_eks_cluster.this.name
  namespace       = "kube-system"
  service_account = "ebs-csi-controller-sa"
  role_arn        = aws_iam_role.ebs_csi_role.arn

  depends_on = [
    aws_iam_role_policy_attachment.eks_ebs_csi_policy,
    aws_eks_addon.pod_identity_agent,
  ]
}

resource "aws_eks_addon" "ebs_csi_driver" {
  cluster_name = aws_eks_cluster.this.name
  addon_name   = "aws-ebs-csi-driver"

  depends_on = [
    aws_eks_node_group.nodes,
    aws_eks_pod_identity_association.ebs_csi,
  ]
}
