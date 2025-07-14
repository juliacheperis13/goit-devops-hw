# Terraform AWS Infrastructure – Lesson 5

This project creates a basic AWS infrastructure using Terraform. It includes state file management with S3 and DynamoDB, a VPC network setup, and an Elastic Container Registry (ECR) for Docker image storage.

## 📁 Project Structure

```
lesson-7/
├── main.tf          # Entry point for module integration
├── backend.tf       # Remote backend configuration (S3 + DynamoDB)
├── outputs.tf       # Global outputs from all modules
├── modules/
│   ├── s3-backend/  # Creates S3 bucket and DynamoDB table
│   ├── vpc/         # Builds VPC with subnets and routing
│   └── ecr/         # Creates ECR repository for Docker images
|   └── eks/         # Provisions EKS cluster and node group
│   └── django-chart/# Helm chart for Django application  
└── README.md        # Project documentation
```

## ⚙️ Terraform Commands

Initialize the project:

```bash
terraform init
```

Review planned changes:

```bash
terraform plan
```

Apply changes:

```bash
terraform apply
```

Destroy the infrastructure:

```bash
terraform destroy
```

## 🧹 Module Descriptions

### `s3-backend`

* Creates an S3 bucket with versioning enabled
* Creates a DynamoDB table for state file locking
* Used as a remote backend for storing `.tfstate` files
* Outputs:

  * S3 bucket URL
  * DynamoDB table name

### `vpc`

* Creates a VPC with CIDR block `10.0.0.0/16`
* Adds:

  * 3 public subnets
  * 3 private subnets
* Includes an Internet Gateway and NAT Gateway
* Sets up routing tables for both public and private subnets
* Outputs:

  * VPC ID
  * Subnet lists

### `ecr`

* Creates an AWS Elastic Container Registry (ECR) repository
* Enables automatic image scanning on push for vulnerabilities
* Sets a basic repository access policy (read access to everyone — for demo purposes)
* Outputs:

  * ECR repository URL


### `ekc`
* EKS cluster with
  * Managed node group
  * Configurable instance type and size
* Outputs: cluster name, kubeconfig context


## Docker: Build & Push to ECR

Use the script below to build a multi-architecture Docker image and push it to ECR:

```bash
#!/bin/bash

AWS_REGION=""
ACCOUNT_ID=""
REPO=""
IMAGE_TAG="latest"
ECR_URL="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO}"

aws ecr get-login-password --region $AWS_REGION \
  | docker login --username AWS --password-stdin $ECR_URL

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${ECR_URL}:${IMAGE_TAG} . \
  --push
```

> Make sure Docker Buildx and QEMU are enabled for multi-platform builds.

---


##  How to Work with Helm

This project includes a custom Helm chart in `modules/django-chart/` for deploying a Django application to EKS.

### 1. Connect to EKS cluster

Make sure your kubeconfig is up to date:

```bash
aws eks --region us-east-1 update-kubeconfig --name eks-cluster-demo
```

### 2. Deploy the application

```bash
helm upgrade --install django-app ./modules/django-chart -f ./modules/django-chart/values.yaml
```

This will:

- Use your custom Docker image from ECR
- Create a Kubernetes Deployment and Service
- (If enabled) Create an HPA object

### 3. Check that it works

```bash
kubectl get pods
kubectl get svc
```

Once the `EXTERNAL-IP` appears under the LoadBalancer service, you can open it in a browser.

### 4. Update values and redeploy

After modifying `values.yaml`, run:

```bash
helm upgrade django-app ./modules/django-chart -f ./modules/django-chart/values.yaml
```

### 5. Uninstall the app

```bash
helm uninstall django-app
```

This removes all associated Kubernetes resources created by the chart.
