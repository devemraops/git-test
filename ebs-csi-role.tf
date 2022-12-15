#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn
#data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn

# Resource: Create EBS CSI IAM Policy 
# resource "aws_iam_policy" "ebs_csi_iam_policy" {
#   name        = "${local.name}-AmazonEKS_EBS_CSI_Driver_Policy"
#   path        = "/"
#   description = "EBS CSI IAM Policy"
#   policy = data.http.ebs_csi_iam_policy.body
# }

# output "ebs_csi_iam_policy_arn" {
#   value = aws_iam_policy.ebs_csi_iam_policy.arn 
# }

# Resource: Create IAM Role and associate the EBS IAM Policy to it
resource "aws_iam_role" "ebs_csi_iam_role4" {
  name = "ebs-csi-iam-role4"

  # Terraform's "jsonencode" function converts a Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRoleWithWebIdentity"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Federated = "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_arn}"
        }
        Condition = {
          StringEquals = {            
            "${data.terraform_remote_state.eks.outputs.aws_iam_openid_connect_provider_extract_from_arn}:sub": "system:serviceaccount:kube-hosts:ebs-csi-controller-sa"
          }
        }        

      },
    ]
  })

  managed_policy_arns = ["arn:aws:iam::541906215541:policy/AmazonEKS_EBS_CSI_Driver_Policy"]

  tags = {
    tag-key = "operations-ebs-csi-iam-role"
  }
}

data "http" "ebs_csi_iam_policy" {
  url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-ebs-csi-driver/master/docs/example-iam-policy.json"

  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
}
# # Associate EBS CSI IAM Policy to EBS CSI IAM Role
# resource "aws_iam_role_policy_attachment" "ebs_csi_iam_role_policy_attach" {
#   policy_arn = aws_iam_policy.ebs_csi_iam_policy.arn 
#   role       = aws_iam_role.ebs_csi_iam_role.name
# }

# output "ebs_csi_iam_role_arn" {
#   description = "EBS CSI IAM Role ARN"
#   value = aws_iam_role.ebs_csi_iam_role.arn
# }




