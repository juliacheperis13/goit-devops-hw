# Terraform AWS Infrastructure with Jenkins, ArgoCD, and EKS

This project provisions a complete AWS-based DevOps setup using Terraform. It includes remote state management, a VPC network, an EKS cluster, an ECR repository, Jenkins for CI/CD, and Argo CD for GitOps.

---

## 🧱 Module Descriptions

### `s3-backend`
* Creates an S3 bucket with versioning
* Creates a DynamoDB table for Terraform state locking
* Used as a remote backend for `.tfstate`
* Outputs:
  * S3 bucket name
  * DynamoDB table name

### `vpc`
* Creates a VPC with CIDR block `10.0.0.0/16`
* Adds:
  * 3 public subnets
  * 3 private subnets
* Sets up:
  * Internet Gateway
  * NAT Gateway
  * Route tables
* Outputs:
  * VPC ID
  * Subnet IDs

### `ecr`
* Creates an Elastic Container Registry
* Enables image scanning
* Outputs:
  * ECR repo URL

### `eks`
* Creates an EKS cluster
* Adds:
  * IAM roles and OIDC provider
  * Managed node group (with configurable instance type)
* Outputs:
  * EKS cluster name
  * Kubeconfig context

### `jenkins`
* Installs Jenkins via Helm chart
* Sets up:
  * Persistent volume
  * Pre-installed plugins
  * JCasC with GitHub credentials and seed job
  * Kaniko agent pod template with IAM role for ECR access
* Outputs:
  * Jenkins LoadBalancer URL

### `argo_cd`
* Installs Argo CD via Helm
* Sets up:
  * Application and repo secrets via values
  * Git-based deployments of Django app
* Outputs:
  * Argo CD LoadBalancer URL

---

## 🚀 CI/CD Pipeline with Jenkins

Jenkins runs a seed job from a GitHub repo to create a pipeline job `goit-django-docker`. The pipeline:

1. Builds a Docker image using Kaniko
2. Pushes it to ECR
3. Updates Helm `values.yaml` with the new tag
4. Commits and pushes the change

### Triggering

The pipeline job must be triggered manually in Jenkins UI. 
---

## 🥪 Argo CD GitOps

Argo CD watches the Git repo and syncs the Helm chart to Kubernetes.

### Repo Structure

```
goit-devops-hw/
├── charts/
│   └── django-app/         # Helm chart
├── django/                # Django app code
└── Jenkinsfile
```


## ⚙️ Terraform Initialize Commands

```bash
terraform init     # Initialize the working directory
terraform plan     # Preview the infrastructure changes
terraform apply    # Apply the changes to reach the desired state
```

---

## Steps

Now that the environment is ready, you can proceed with the following steps.

### Connect kubectl to your cluster:

```bash
aws eks update-kubeconfig --region us-east-1 --name <your_cluster_name>
```

### Check the services in the cluster:

```bash
kubectl get svc -A
```

You can find URL to created resources in LoadBalancer column in output.

### Open Jenkins LoadBalancer URL

Use the link printed from Terraform output:

```
http://<jenkins-lb-url>
```

**Login:** `admin`\
**Password:** `admin123`

### Run Jenkins Jobs

1. Run the `seed-job` job (this creates the `goit-django-docker` pipeline job)
2. Run the `goit-django-docker` job manually

The `goit-django-docker` job will:

- Build and push Docker image to ECR
- Update the app version in the Helm chart
- Commit and push changes to your GitHub repo

### Open Argo CD LoadBalancer URL

Check the status of the application — it should be **Healthy** and **Synced**.


### Deploy Manually (Optional)

```bash
aws eks --region us-east-1 update-kubeconfig --name <cluster-name>
helm upgrade --install django-app ./charts/django-app -f ./charts/django-app/values.yaml
```

---

## 🐳 Docker: Build & Push to ECR (Alternative to Jenkins)

```bash
#!/bin/bash
AWS_REGION="us-east-1"
ACCOUNT_ID="<your-account-id>"
REPO="lesson-5-ecr"
IMAGE_TAG="v1.0.0"
ECR_URL="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPO}"

aws ecr get-login-password --region $AWS_REGION \
  | docker login --username AWS --password-stdin $ECR_URL

docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t ${ECR_URL}:${IMAGE_TAG} . \
  --push
```

---

## ✅ Useful Commands

```bash
kubectl get pods -n jenkins
kubectl get svc -n jenkins
kubectl get svc -n argocd
kubectl get pods -n argocd
```

---

## 📜 Notes

Don’t forget to define all required variables (e.g. `github_user`, `github_pat`, `github_repo_url`) in `terraform.tfvars`

---

## ⚙️ Terraform Destory Commands

```bash
terraform destroy    # Destroy resources
```

---

Happy deploying! 
