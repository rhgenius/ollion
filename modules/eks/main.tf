# Create EKS Clusters (Test, Stage, Prod)
resource "aws_eks_cluster" "clusters" {
  for_each = var.eks_cluster_names

  name     = each.value
  role_arn = var.eks_cluster_role_arn
  version  = "1.27"

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
  }

  tags = {
    Name        = each.value
    Environment = each.key
  }
}

# Create EKS Node Groups for each cluster
resource "aws_eks_node_group" "node_groups" {
  for_each = var.eks_cluster_names

  cluster_name    = aws_eks_cluster.clusters[each.key].name
  node_group_name = "${each.value}-node-group"
  node_role_arn   = var.eks_node_role_arn
  subnet_ids      = var.private_subnet_ids
  instance_types  = var.eks_node_group_instance_types[each.key]

  scaling_config {
    desired_size = var.eks_node_group_desired_size[each.key]
    max_size     = var.eks_node_group_max_size[each.key]
    min_size     = var.eks_node_group_min_size[each.key]
  }

  update_config {
    max_unavailable = 1
  }

  tags = {
    Name        = "${each.value}-node-group"
    Environment = each.key
  }
}