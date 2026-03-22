# ECS Fargate Deployment for servicea and serviceb

This project deploys two Go services, `servicea` and `serviceb`, to AWS ECS Fargate using Terraform.
It provisions:

- VPC
- Public subnets
- Application Load Balancer
- Target groups and listener rules
- ECR repositories
- ECS cluster
- ECS task definitions
- ECS services
- CloudWatch log groups
- ECS autoscaling

## Services

- `servicea`
- `serviceb`

## Infrastructure Overview

- VPC CIDR: 10.0.0.0/16
- ALB is deployed in public subnets
- ECS tasks are currently deployed in public subnets
- Container images are stored in ECR
- Logs are sent to CloudWatch

## Initial Deployment Flow

The first deployment is usually done in this order:

## 1. Create ECR repositories

```
terraform init
terraform apply -target=module.ecr
```

This creates ECR repositories for:

- `servicea-<env>`
- `serviceb-<env>`

## 2. Login to ECR

Set your values:

```
export AWS_REGION=ap-southeast-2
export AWS_ACCOUNT_ID=123456789012
export ENV=dev
```

Login to ECR:

```
aws ecr get-login-password --region $AWS_REGION | \
docker login --username AWS --password-stdin $AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com
```

## 3. Build and push Docker images

### servicea

Build:

```
docker build -t servicea:latest ./servicea
```

Tag:

```
docker tag servicea:latest \
$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/servicea-$ENV:latest
```

Push:

```
docker push \
$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/servicea-$ENV:latest
```

### serviceb

Build:

```
docker build -t serviceb:latest ./serviceb
```

Tag:

```
docker tag serviceb:latest \
$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/serviceb-$ENV:latest
```

Push:

```
docker push \
$AWS_ACCOUNT_ID.dkr.ecr.$AWS_REGION.amazonaws.com/serviceb-$ENV:latest
```

## 4. Terraform apply

After the images are pushed, deploy the rest of the infrastructure:

```
terraform apply
```
