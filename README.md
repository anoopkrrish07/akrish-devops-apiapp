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
│       └── aws_vpc
│           ├── backend.tf
│           ├── main.tf
│           ├── outputs.tf
│           ├── provides.tf
│           ├── variables.tf
│           └── versions.tf
└── kube_deploy
    └── helm-charts
        ├── app-charts
        │   ├── api-app
        │   │   └── app-passgen-api
        │   │       ├── Chart.yaml
        │   │       ├── charts
        │   │       ├── templates
        │   │       │   ├── NOTES.txt
        │   │       │   ├── _helpers.tpl
        │   │       │   ├── deployment.yaml
        │   │       │   ├── hpa.yaml
        │   │       │   └── service.yaml
        │   │       └── values.yaml
        │   └── env_values
        │       ├── dev
        │       │   └── app-passgen-api
        │       │       ├── dev-values-passgen-v1.yaml
        │       │       └── dev-values-passgen-v2.yaml
        │       └── prod
        └── common-charts
```
## Tools used:
- Terraform (v1.8.1)
- EKS (v1.28)
- Karpenter Chart (v0.36)
- Python (v3.12.2)
- Helm (v3.14.2)

## Prerequisite:
- An AWS account
- Clone repository and make changes
- Add Terraform backend configuration
- AWS - GitHub OIDC access
- Add variables as GitHub secrets

## How to deploy: