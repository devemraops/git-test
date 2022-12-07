resource "aws_iam_role" "worker_role" {
  name =local.eks_worker_name

  assume_role_policy = jsonencode({
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "ec2.amazonaws.com"
      }
    }]
    Version = "2012-10-17"
  })

  managed_policy_arns = ["arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",  "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
  "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly", "arn:aws:iam::aws:policy/AWSKeyManagementServicePowerUser"]


  tags = {
    "Name" = local.eks_worker_role_name
  }
}



# # This policy allows Amazon EKS worker nodes to connect to Amazon EKS Clusters.
# resource "aws_iam_role_policy_attachment" "yellow-AmazonEKSWorkerNodePolicy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
#   role       = aws_iam_role.first.name
# }

# # This policy provides the Amazon VPC CNI Plugin (amazon-vpc-cni-k8s) 
# # the permissions it requires to modify the IP address configuration on your EKS worker nodes.
# resource "aws_iam_role_policy_attachment" "yellow-AmazonEKS_CNI_Policy" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
#   role       = aws_iam_role.first.name
# }


# # Provides read-only access to Amazon EC2 Container Registry repositories.
# resource "aws_iam_role_policy_attachment" "yellow-AmazonEC2ContainerRegistryReadOnly" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
#   role       = aws_iam_role.first.name
# }

resource "aws_eks_node_group" "general" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = local.eks_worker_name
  node_role_arn   = aws_iam_role.worker_role.arn

  # Identifiers of ec2 subnewts to associate with the EKS Node Group.
  # This subnets must have the following resource tag: kubernetes.io/cluster/CLUSTER_NAME
  # (where cluster_name is replaced with the same of eks cluster).
  subnet_ids = [
    aws_subnet.eks-private1.id,
    aws_subnet.eks-private2.id,
    aws_subnet.eks-private3.id
  ]

  # Configuration block with scaling settings
  scaling_config {
    # Desired number of worker nodes
    desired_size = var.desired_size
    max_size     = var.max_size
    min_size     = var.min_size
  }

  remote_access {
    ec2_ssh_key = "eks-terraform-key"
  }

  update_config {
    max_unavailable_percentage = 50
  }
  # Type of Amazon Machine Image (AMI) associated with the EKS Node Group.
  # Valid values: AL2_x86_64, AL2_x86_64_GPU, AL2_ARM_64
  ami_type = var.ami_type

  # Type of capacity associated with the EKS Node Group.
  # Valid values: ON_DEMAND, SPOT
  capacity_type = var. capacity_type #"ON_DEMAND"

  # Disk size in GIB for worker nodes
  disk_size = var.disk_size

  # Force version update if existing pods are unable to be drained due to a pod distruption budget issue.
  force_update_version = false

  # list of instance types associated with the EKS Node Group.
  instance_types =["t2.medium"]
    
    tags = {
      "Name" = local.eks_worker_role_name
    }
    
    # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
    # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
         aws_iam_role.worker_role
  ]
}


