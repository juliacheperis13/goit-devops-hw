#!/bin/bash

AWS_REGION=""
ACCOUNT_ID=""
REPOSITORY_NAME=""
IMAGE_TAG="latest"
PLATFORMS="linux/amd64,linux/arm64"

ECR_URL="${ACCOUNT_ID}.dkr.ecr.${AWS_REGION}.amazonaws.com/${REPOSITORY_NAME}"

echo "🔐 Logging into AWS ECR..."
aws ecr get-login-password --region $AWS_REGION | docker login --username AWS --password-stdin $ECR_URL
if [ $? -ne 0 ]; then
  echo "❌ Login to ECR failed. Перевір AWS CLI або права доступу."
  exit 1
fi

echo "📦 Checking ECR repository existence..."
aws ecr describe-repositories --repository-names $REPOSITORY_NAME --region $AWS_REGION >/dev/null 2>&1
if [ $? -ne 0 ]; then
  echo "📁 Creating ECR repository $REPOSITORY_NAME ..."
  aws ecr create-repository --repository-name $REPOSITORY_NAME --region $AWS_REGION
fi

if ! docker buildx inspect multi-builder >/dev/null 2>&1; then
  echo "🛠️  Creating buildx builder..."
  docker buildx create --name multi-builder --use
fi

echo "🚀 Building and pushing Docker image to $ECR_URL:$IMAGE_TAG for platforms: $PLATFORMS"
docker buildx build \
  --platform $PLATFORMS \
  -t $ECR_URL:$IMAGE_TAG \
  . \
  --push

if [ $? -eq 0 ]; then
  echo "✅ Done! Image pushed to: $ECR_URL:$IMAGE_TAG"
else
  echo "❌ Build or push failed."
  exit 1
fi
