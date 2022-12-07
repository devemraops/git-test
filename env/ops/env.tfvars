application = "cluster"
env = "ops"
eks_role_name = "ops-cluster"
service= "eks"
cluster_version = "1.23"
region = "us-east-1"
eks_worker_role_name = "ops-workers"
node_group_name = "ops-workers"
instance_type = ["t2.medium"]
desired_size = 2
max_size = 4
min_size = 1
ami_type = "AL2_x86_64"
capacity_type = "ON_DEMAND"
disk_size = 25


# eksctl create iamidentitymapping \
#     --cluster ops-cluster \
#     --region=us-east-1 \
#     --arn arn:aws:iam::541906215541:root \
#     --group cluster-admin \
#     --no-duplicate-arns \
#     --profile silver

#     eksctl delete iamidentitymapping \
#     --cluster ops-cluster \
#     --region=us-east-1 \
#     --arn arn:aws:iam::541906215541:user/root \
#     --profile silver