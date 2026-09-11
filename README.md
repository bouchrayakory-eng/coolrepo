# Cloud Resume Challenge & Containerized API Platform

[![AWS](https://img.shields.io/badge/AWS-232F3E?style=flat-square&logo=amazon-aws&logoColor=white)](https://aws.amazon.com/)
[![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=flat-square&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Docker](https://img.shields.io/badge/Docker-2496ED?style=flat-square&logo=docker&logoColor=white)](https://www.docker.com/)
[![GitHub Actions](https://img.shields.io/badge/GitHub_Actions-2088FF?style=flat-square&logo=github-actions&logoColor=white)](https://github.com/features/actions)

An enterprise-grade, serverless, and containerized portfolio platform built on AWS as part of the **Cloud Resume Challenge**.

This repository demonstrates complete **Infrastructure as Code (IaC)** using Terraform, continuous integration and deployment (CI/CD) via GitHub Actions, static web hosting over CDN, and dual-backend microservices (Serverless Lambda + Containerized ECS Fargate).

---

## 🏛️ Architecture Overview

The system features dual CloudFront origin routing—serving static assets directly from S3 while securely proxying `/api/*` requests to an Application Load Balancer (ALB) running on ECS Fargate.

```text
[ Browser / Client ]
         │
         ▼
 ┌─────────────────────────────────────────────────────────┐
 │             AWS CloudFront CDN (HTTPS)                  │
 └─────────────┬─────────────────────────────┬─────────────┘
               │ (Default Route /*)          │ (API Route /api/*)
               ▼                             ▼
   ┌───────────────────────┐    ┌──────────────────────────┐
   │    Amazon S3 Bucket    │    │ Application Load Balancer│
   │   (Static Bootstrap)  │    └────────────┬─────────────┘
   └───────────────────────┘                 │
                                             ▼
                                ┌──────────────────────────┐
                                │   AWS ECS Fargate Task   │
                                │  (Containerized Flask)   │
                                └──────────────────────────┘
                                             │
                                             ▼
                                ┌──────────────────────────┐
                                │   Amazon ECR Registry    │
                                └──────────────────────────┘

 [ Separate Async Route: /visitor-count ]
   Client ──► API Gateway ──► AWS Lambda ──► DynamoDB Table
```

---

## 🛠️ Tech Stack & Key Technologies

* **Frontend:** HTML5, Bootstrap 5, JavaScript (Fetch API), CSS3
* **CDN & Edge Security:** AWS CloudFront (OAC, HTTPS/TLS, Dual Origins)
* **Static Hosting:** Amazon S3
* **Containerized Microservice:** Python Flask API, Docker, Amazon ECR, AWS ECS Fargate, ALB
* **Serverless Visitor Counter:** Amazon API Gateway, AWS Lambda, Amazon DynamoDB
* **Infrastructure as Code:** Terraform
* **CI/CD Pipeline:** GitHub Actions (Automated S3 Sync, ECR Build/Push, ECS Service Redeployment, CDN Invalidation)

---

## 🚀 Key Infrastructure Features

1. **Dual-Origin CloudFront Proxying:** Eliminates Cross-Origin Resource Sharing (CORS) friction by routing static frontend assets and containerized `/api/*` endpoints under a single HTTPS domain.
2. **Serverless Visitor Tracking:** Asynchronously counts unique page views using AWS Lambda and DynamoDB without blocking UI page loads.
3. **Automated Docker Image Pipelines:** GitHub Actions builds, tags (Git SHA + `latest`), pushes to ECR, and forces a zero-downtime deployment on ECS Fargate.
4. **Least-Privilege Security:** IAM Roles, Security Groups, and Origin Access Control (OAC) restrict public access exclusively to CloudFront.

---

## 💻 Local Development & Infrastructure Deployment

### Prerequisites
* [Terraform](https://www.terraform.io/) >= 1.0
* [AWS CLI](https://aws.amazon.com/cli/) configured with deployment credentials
* [Docker Desktop](https://www.docker.com/)

### 1. Initialize and Provision Infrastructure
```bash
# Clone repository
git clone [https://github.com/bouchrayakory-eng/coolrepo.git](https://github.com/bouchrayakory-eng/coolrepo.git)
cd coolrepo

# Initialize Terraform modules and providers
terraform init

# Review and provision cloud infrastructure
terraform plan
terraform apply -auto-approve
```

### 2. Build and Push Container API Locally
```bash
# Authenticate Docker to Amazon ECR
ECR_URL=$(terraform output -raw ecr_repository_url)
aws ecr get-login-password --region us-east-1 | docker login --username AWS --password-stdin $ECR_URL

# Build and push Flask container
docker build -t $ECR_URL:latest .
docker push $ECR_URL:latest
```

---

## 🔄 CI/CD Automation Workflow

The included GitHub Actions workflow (`.github/workflows/deploy.yml`) automatically triggers on every push to the `main` branch:

1. **Frontend Job:** Syncs `website/` to the S3 bucket and invalidates the CloudFront distribution cache.
2. **Backend Job:** Builds the Python Docker container, pushes the new image tag to Amazon ECR, and executes `aws ecs update-service --force-new-deployment`.

---

## 📄 License

Distributed under the MIT License. See `LICENSE` for more information.
