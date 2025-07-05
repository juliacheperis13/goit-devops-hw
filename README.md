# Terraform AWS Infrastructure – Lesson 5

This project creates a basic AWS infrastructure using Terraform. It includes state file management with S3 and DynamoDB, a VPC network setup, and an Elastic Container Registry (ECR) for Docker image storage.

## 📁 Project Structure

```
lesson-5/
├── main.tf          # Entry point for module integration
├── backend.tf       # Remote backend configuration (S3 + DynamoDB)
├── outputs.tf       # Global outputs from all modules
├── modules/
│   ├── s3-backend/  # Creates S3 bucket and DynamoDB table
│   ├── vpc/         # Builds VPC with subnets and routing
│   └── ecr/         # Creates ECR repository for Docker images
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

