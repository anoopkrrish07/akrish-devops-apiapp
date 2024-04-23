# Python API Password Generator Application Deployment on EKS with Karpenter:

## Overview:

This repository has a Python API Application for generating passwords, deployed on an AWS EKS Cluster using Helm charts. The application responds to API requests at the "/generate-passwords" endpoint, which takes parameters to generate random passwords. The entire process "from image building and application deployment to infrastructure setup" is managed through GitHub Actions workflows. Also, we are implementing a Blue-Green deployment strategy to manage application rollouts.

## What we have achieved:

- Dockerized the application for containerization.
- Developed a Helm chart to facilitate application deployment.
- Created a custom VPC specifically for the application using Terraform.
- Managed EKS infrastructure code using the official Terraform module, with the help of Karpenter for node provisioning.
- Deployed infrastructure through a GitHub Actions workflow, enabling manual triggers via workflow dispatch.
- Established a CI pipeline to build the Docker image and publish it to a private ECR repository.
- Set up a CD pipeline to deploy the application onto the EKS cluster.

## Architecture Diagram

!["Architecture"](assets/architecture.png?raw=true)

## Repo Tree:

```
.
├── README.md
├── api_app
│   ├── Dockerfile
│   └── app_dir
│       ├── main.py
│       └── requirements.txt
├── assets
│   └── architecture.png
├── infra_iac
│   ├── tf_main
│   │   └── region
│   │       ├── dev
│   │       │   ├── aws_eks.tfvars
│   │       │   └── aws_vpc.tfvars
│   │       └── prod
│   │           └── aws_vpc.tfvars
│   └── tf_modules
│       ├── aws_eks
│       │   ├── aws-ecr.tf
│       │   ├── backend.tf
│       │   ├── datasource.tf
│       │   ├── karpenter.tf
│       │   ├── locals.tf
│       │   ├── main.tf
│       │   ├── outputs.tf
│       │   ├── providers.tf
│       │   ├── variables.tf
│       │   └── versions.tf
│       └── aws_vpc
│           ├── backend.tf
│           ├── main.tf
│           ├── outputs.tf
│           ├── provides.tf
│           ├── variables.tf
│           └── versions.tf
└── kube_deploy
    ├── helm-charts
    │   ├── app-charts
    │   │   ├── api-app
    │   │   │   └── app-passgen-api
    │   │   │       ├── Chart.yaml
    │   │   │       ├── charts
    │   │   │       ├── templates
    │   │   │       │   ├── NOTES.txt
    │   │   │       │   ├── _helpers.tpl
    │   │   │       │   ├── deployment.yaml
    │   │   │       │   ├── hpa.yaml
    │   │   │       │   └── service.yaml
    │   │   │       └── values.yaml
    │   │   └── env-values
    │   │       ├── dev
    │   │       │   └── app-passgen-api
    │   │       │       └── dev-values-passgen.yaml
    │   │       └── prod
    │   └── common-charts
    └── manifests
        └── karpenter-provisioner
            ├── node-class
            │   └── default-nc.yaml
            └── node-pool
                └── default-np.yaml
```
## Tools used:
- Terraform (v1.8.1)
- EKS (v1.28)
- Karpenter Chart (v0.36)
- Python (v3.12.2)
- Helm (v3.14.2)

## Prerequisite:
- An AWS account
- Clone repository and make required changes
- AWS - GitHub OIDC access (Create)

## How to deploy:

### Pre-deploy steps:
1. Create AWS GitHub OIDC access for the terraform infrastructure and application deployment. Refer this link for it: [LINK](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)
2. Create a S3 bucket and dynamoDB table and update the backend file (`backend.tf`) for the terraform state management.
3. Update appropriate image name and tag in the helm custom values file (`dev-values-passgen.yaml`).
4. Add these variables in the GitHub secrets.
```yaml
## In both pipelines
DEV_AWS_ROLE_ARN = OIDC assume role arn
## Only in deployment pipeline
AWS_ECR_REPO  = Your ECR repo name
```
5. Update these variables in the pipeline
```yaml
## Deployment Pipeline
AWS_DEFAULT_REGION = Specify the region of your OIDC role
EKS_CLUSTER_NAME = Your created EKS cluster name
NAMESPACE = Kubernetes Namespace of your application
IMAGE_TAG = Image tag for the ECR image
```

### Infrastructure deployment

The following services have to be deployed through GitHub Actions:

1. AWS VPC
2. AWS EKS

Infrastructure can be deployed manually through GitHub Actions workflow_dispatch:

`Go to Actions > select workflow (TF AWS Infrastructure Deployment) > run workflow > add region (eg: us-east-2) > select environment > select terraform action (eg: plan or apply) > select AWS service you want to deploy > trigger using run workflow`

> Note: The pipeline does not include a resource destruction step; this must be handled manually if needed.

### Application deployment

Application pipeline is triggered through a semantic Tag release. This will build the image and push it to the ECR repository, then the deployment will be carried out using helm release.

> Note: You may need to create a service account (with IRSA arn) for pulling the images from ECR.

### Access the application

Access the application using the Load Balancer endpoint, for generating the password we can trigger the API endpoint with a POST request with parameters.

`curl -X POST http://<loadbalancer-endpoint>/generate-passwords -H "Content-Type: application/json" -d '{"min_length": 10, "special_chars": 2, "numbers": 3, "num_passwords": 5}'`

> Note: Can also use postman for testing API request.

## Improvements

- Blue-Green Deployment (This can be achieved using Flagger, Flagger + FluxCD or Argo Rollouts)
- Ingress for better traffic distribution (Possible options Istio Gateway or NGINX Ingress Controller)

## Conclusion

This repository helps you deploy a Python API Application on AWS EKS, using tools like Helm, Terraform, and Karpenter to achieve highly available and consistent infrastructure. While the setup is designed for development and testing, it offers a great way to get familiar with deploying containerized applications in a cloud environment. Just a heads-up, this isn’t suited for production use.
