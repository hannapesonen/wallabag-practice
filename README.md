# Wallabag DevOps Practice Environment

This repository contains a DevOps‑oriented deployment of **Wallabag** as a containerized application on Azure. The goal of this project is to practice DevOps workflows using **Infrastructure as Code**, **container registries**, **Azure Container Apps**, and **managed databases**.

---

## Project Objectives

- Provide a reproducible, IaC‑driven deployment of a real but relatively simple app, in this case Wallabag  
- Get more comfortable working with images by importing an upstream container image into Azure Container Registry  
- Deploy Wallabag as an Azure Container App  
- Provision and integrate a managed PostgreSQL database  
- Establish a foundation for future DevOps enhancements (CI/CD, monitoring, secrets management)

---

## Architecture Overview

The deployment consists of the following components:

- **[Wallabag Container]** — Imported directly from upstream Wallabag image into Azure Container Registry using az acr import  
- **[Azure Container Registry]** — Stores the Wallabag image  
- **[Azure Container Apps]** — Runs the Wallabag application in a serverless container environment  
- **[Azure Database for PostgreSQL]** — Managed database backend  
- **[Terraform IaC]** — Provisions all infrastructure components
- **[GitHub Actions workflow]** — Checks for updates to the Wallabag image

A high‑level first infra flow:
Deploy core infrastructure via Terraform → Import Wallabag official image into ACR → Deploy ACA via Terraform → ACA pulls image → App connects to PostgreSQL

Github Actions workflow
Use cron to pull upstream image → compare digest to image in ACR → if different, push update to ACR and update Container App with Terraform
Uses Azure Service Principal for authentication 

---

## Repository Structure
```
/wallabag
|-- README.md
|-- compose-wallabag.yml
|-- env.example
`-- infra/
    |-- acr.tf
    |-- container_app.tf
    |-- container_env_vars.tf
    |-- container_secrets.tf
    |-- locals.tf
    |-- main.tf
    |-- outputs.tf
    |-- postgres.tf
    |-- providers.tf
    |-- storage.tf
    |-- terraform.tfvars
    `-- variables.tf
```
---

## Deployment Workflow

The deployment follows a two‑phase approach: first provisioning core infrastructure, then importing and deploying the application image, then deploying the app. This could be streamlined, it now requires commenting out parts of the code temporarily. 

### 1. Provision core infrastructure with Terraform
Terraform creates all required Azure resources except the Container App itself, including:

- Azure Container Registry (ACR)
- Azure Database for PostgreSQL
- Azure Container Apps Environment
- Supporting resources such as a Storage Account

The Container App is deployed only after the image is available in ACR. This is done in practice at the moment by commenting out the ACA part of container_app.tf

### 2. Import the Wallabag image into ACR
Once ACR exists, the official upstream Wallabag image is imported directly from Docker Hub:
```
az acr import \
--name <acr-name> \
--source docker.io/wallabag/wallabag:latest \
--image wallabag:latest
```

### 3. Deploy the Azure Container App with Terraform
Uncomment relevant parts of container_app.tf and Terraform deploys the Container App, referencing the imported image.

### 4. Azure Container Apps pulls the image
The Container App automatically pulls the imported image from ACR and starts the Wallabag container.

### 5. Wallabag connects to PostgreSQL
Connection details are provided via Terraform‑managed environment variables and secrets.

---

## Prerequisites

- Azure CLI 
- Terraform

---

## How to Deploy

### 1. Initialize Terraform
`terraform init`


### 2. Review and apply the plan
```
terraform plan
terraform apply
```


### 4. Retrieve the container app URL
Included in the `outputs.tf`

---

## Secrets & configuration

Secrets such as database credentials are currently stored using:
- Terraform variables (`.tfvars` file not committed to the repo)  

---

## Future enhancements

- Azure Key Vault for secrets management
- Managed identity for authentication
- Add CI/CD pipelines (using GitHub Actions) to monitor for updates to the image [x]
- Add monitoring and alerts via Azure Monitor / Log Analytics  
- Consider security scanning  
- Write instructions / documentation

