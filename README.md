
# ECS-Project - AWS Threat Composer App Hosted on ECS with Terraform 👾

`This project is based on Amazon's Threat Composer Tool, an open source tool designed to facilitate threat modeling and improve security assessments.
`

![threat-composer-gif.gif](images/threat-composer-gif.gif)

## Overview of the setup
This repository provisions a small, production-style AWS deployment of the AWS Threat Modeling Tool Application using Terraform modules.

### Infrastructure (AWS)
- **Region + AZs**: Deployed in **eu-west-2** across **two Availability Zones** for resilience.
- **Networking (VPC)**: Dedicated VPC with **public** and **private** subnets.
- **Ingress (ALB)**: An **internet-facing Application Load Balancer** sits in the public subnets and is the only public entry point.
- **Compute (ECS Fargate)**: An **ECS Fargate Service** runs the container in private subnets using **`awsvpc`** networking (each task gets its own ENI/IP).
- **Routing**: ALB listener forwards traffic to an **ALB Target Group** (target type `ip`) which registers the ECS tasks.
- **DNS + TLS**:
    - **Route 53** hosts the domain and uses an **Alias A record** (`ecs.saahirmir.com`) to point to the ALB.
    - **ACM** provides the TLS certificate used by the ALB **HTTPS (443)** listener.
- **Egress (private)**: Private subnet egress is handled via a **Regional NAT Gateway** (where required) so tasks can reach the internet without being publicly addressable ie to ECR.
- **Security groups (least privilege)**:
    - ALB SG allows inbound **80/443** from the internet.
    - Task SG only allows inbound on the app port **from the ALB SG** (no direct public access).

### Terraform approach (best-practice structure)
- **Modular design**: Infrastructure is broken into focused modules: `vpc`, `sg`, `alb`, `acm`, `ecs`.
- **Clear interfaces**: Module inputs/outputs are wired in `infra/main.tf`, keeping concerns separated and reusable.

### CI/CD (GitHub Actions)
- **OIDC to AWS (no long-lived keys)**: Workflows authenticate to AWS using **GitHub Actions OIDC** and `aws-actions/configure-aws-credentials`, assuming an IAM role with short-lived credentials (instead of storing AWS access keys in GitHub secrets).
    - GitHub OIDC docs: https://docs.github.com/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services
    - AWS credentials action: https://github.com/aws-actions/configure-aws-credentials
- **Repo variables for configuration**: Non-sensitive settings (e.g. account/region/image tag names) are stored as **GitHub repository variables**, keeping workflows clean and avoiding hard-coded values.
- **Pipeline gating (approvals)**: Terraform **apply** / **destroy** stages are protected by environment rules so deployments require approval before running.
    - Environments + protection rules: https://docs.github.com/actions/deployment/targeting-different-environments/using-environments-for-deployment
- **Concurrency control**: Deployment workflows use **concurrency** to prevent overlapping applies/destroys and reduce the risk of state conflicts.
    - Concurrency docs: https://docs.github.com/actions/writing-workflows/choosing-what-your-workflow-does/control-the-concurrency-of-workflows-and-jobs

### Security scanning
- **Container image scanning**: Trivy scans are run during image publishing to catch vulnerabilities before pushing/deploying.
    - Trivy GitHub Action: https://github.com/aquasecurity/trivy-action
- **Terraform / IaC scanning**: Trivy is also used for **IaC misconfiguration scanning** of Terraform before deployment.
    - Trivy Terraform scanning: https://trivy.dev/docs/v0.50/tutorials/misconfiguration/terraform/

### Shift-left security (pre-commit)

This repo uses the **pre-commit** framework to run security and quality checks locally before changes land in Git, so misconfigurations 
and risky patterns are caught early instead of during terraform apply. 

Hooks include Terraform formatting and Terraform-focused scanners 
**(via pre-commit-terraform)**, plus **Checkov** and **Trivy** misconfiguration scanning for **Terraform/IaC;** supporting hygiene checks like 
**YAML formatting** and **workflow/Docker linting** help keep CI and container build files clean as well.

## Diagram Overview of the Architecture:
![Network-diagram.png](images/Network-diagram.png)

## Proof of application working
![Threat-app-running-proof.png](images/Threat-app-running-proof.png)

## Successful Pipeline Runs:
### Docker Image Publish
![Pipeline success ss 2026-02-07 at 19.45.38.png](images/Pipeline%20success%20ss%202026-02-07%20at%2019.45.38.png)
### Terraform Plan + Apply
![Pipeline success ss 2026-02-07 at 19.46.06.png](images/Pipeline%20success%20ss%202026-02-07%20at%2019.46.06.png)
### Terraform Plan + Destroy
![Pipeline success ss 2026-02-07 at 19.45.56.png](images/Pipeline%20success%20ss%202026-02-07%20at%2019.45.56.png)
### Domain URL Health Check
![Pipeline success ss 2026-02-07 at 19.45.47.png](images/Pipeline%20success%20ss%202026-02-07%20at%2019.45.47.png)

## Learning and Reflections

The biggest takeaway from this project was that most “it doesn’t work” moments came down to **networking fundamentals**. 

I learned to slow down and systematically verify the full request path end-to-end: **Route53 -> ALB listener rules -> 
target group health checks -> ECS task networking (subnets/routes) -> security groups (inbound + outbound)**. 

Small mismatches (ports, health check paths, SG references, route tables) can look like an application issue when it’s 
actually just traffic not flowing where you think it is.

On the process side, I reinforced the importance of **staying consistent** and not trying to solve everything in 
one jump. Breaking problems into smaller checks, asking for help when stuck, and avoiding overthinking made the biggest 
difference in getting from “provisioned” to “actually reachable and stable.” 

I also gained appreciation for building in guardrails early (CI gating/approvals, concurrency control, and pre-commit scanning) 
so mistakes can be caught quickly before they become expensive or time-consuming to debug.
