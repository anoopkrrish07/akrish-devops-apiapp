## Global Parameters
env                     = "dev"
group                   = "devops"
app                     = "apiapp"
aws_region              = "us-east-1" #"REGION"

## Network Parameters
vpc_id                  = "<VPC_ID>"

## EKS Parameters
authentication_mode     = "API_AND_CONFIG_MAP"

## Access Entries
# --- EKS ReadOnly Access --- #
readonly_role_arn       = "<role_arn>"
readonly_policy_arn     = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy"

## Node Parameters
capacity_type           = "SPOT"
instance_types          = ["t3a.medium"]

## Karpenter Helm Parameters
set_values = {
  "replicas"                           = 2
  "controller.resources.limits.cpu"    = 1
  "controller.resources.limits.memory" = "1Gi"
}

## ECR Parameters
ecr_name                = "dev-ecr-repo"
