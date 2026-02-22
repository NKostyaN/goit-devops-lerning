# IAM-роль для EC2-вузлів (Worker Nodes)
resource "aws_iam_role" "nodes" {
  # Ім'я ролі для вузлів
  name = "${var.cluster_name}-eks-nodes"

  # Політика, що дозволяє EC2 асумувати роль
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      }
    }
  ]
}
POLICY
}

# Прив'язка політики для EKS Worker Nodes
resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.nodes.name
}

# Прив'язка політики для Amazon VPC CNI плагіну
resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.nodes.name
}

# Прив'язка політики для читання з Amazon ECR
resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.nodes.name
}

# Прив'язка політики для запису до Amazon ECR
resource "aws_iam_role_policy_attachment" "amazon_ecr_power_user" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
  role       = aws_iam_role.nodes.name
}

# Створення Node Group для EKS
resource "aws_eks_node_group" "general" {
  cluster_name = aws_eks_cluster.eks.name
  node_group_name = "general"
  node_role_arn = aws_iam_role.nodes.arn
  subnet_ids = var.subnet_ids
  capacity_type  = "ON_DEMAND"
  instance_types = ["${var.instance_type}"]

  scaling_config {
    desired_size = var.desired_size  # Бажана кількість вузлів
    max_size     = var.max_size      # Максимальна кількість вузлів
    min_size     = var.min_size      # Мінімальна кількість вузлів
  }

  update_config {
    max_unavailable = 1  # Максимальна кількість вузлів, які можна оновлювати одночасно
  }

  labels = {
    role = "general"
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only,
  ]

  lifecycle {
    ignore_changes = [scaling_config[0].desired_size]
  }
}
