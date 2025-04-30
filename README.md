# Vanel's DevOps Technical Test Solution - Enhanced Documentation

This repository contains the complete solution for the DevOps technical test, implemented by **Vanel** with production-grade configurations and detailed explanations for beginners.

---

## 📌 Project Overview

A **PHP web application** deployed on **Google Cloud Run** with:

- **Cloud SQL MySQL** database  
- **Cloud Storage** for static assets  
- **Automated CI/CD pipeline** via GitHub Actions  
- **Infrastructure as Code** using **Terraform**

---

## 📖 Detailed Deployment Guide

### ✅ Prerequisites

#### Google Cloud Account:
- Sign up and access: [https://cloud.google.com](https://cloud.google.com)
- Enable billing (required to activate services)

#### Install Cloud SDK:
```bash
# Installs the gcloud CLI tool to interact with GCP from your terminal
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init  # Authenticate and set default project and region
```

#### Terraform Installation:
```bash
# Download, unzip and install Terraform CLI on a Linux system
wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version  # Confirm installation
```

#### GitHub Account:
- Register at [https://github.com](https://github.com)
- Create a new repository for your project

#### Set up SSH keys:
```bash
# Generate an SSH key for GitHub (used for secure repo access)
ssh-keygen -t ed25519 -C "vanel@example.com"
eval "$(ssh-agent -s)"  # Start the SSH agent
ssh-add ~/.ssh/id_ed25519  # Add your key to the agent
```

---

## 🚀 Deployment Steps

### 1. Terraform Setup and Deployment

```bash
# Clone the repo to your local machine
git clone https://github.com/vanel/devops-solution.git
cd devops-solution/infrastructure  # Navigate to the Terraform directory

# Copy the example tfvars file and configure it with your project-specific values
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars  # Edit the file with your preferred values
```

Sample `terraform.tfvars`:
```hcl
project_id  = "vanel-gcp-project"      # GCP project ID
region      = "europe-west3"           # GCP region to deploy resources
db_name     = "vanel_app_db"           # MySQL DB name
db_user     = "vanel_admin"            # MySQL username
db_pass     = "SecurePassword123!"     # Use strong password here
environment = "production"             # Used for naming & separation
```

```bash
terraform init   # Initialize the Terraform project and download providers
terraform plan   # Preview the actions Terraform will take
terraform apply  # Deploy the infrastructure to GCP (confirm with 'yes' when prompted)
```

To tear down all resources when done:
```bash
terraform destroy  # Remove all created resources
```

---

### 2. GitHub Secrets Configuration

Navigate to your repo > Settings > Secrets > Actions and add:

- `VANEL_GCP_PROJECT`: Your GCP project ID  
- `VANEL_GCP_SA_KEY`: Base64-encoded GCP service account key JSON file content  

Use these commands to set up:

```bash
gcloud config get-value project  # Get current project ID

# Create a CI/CD service account
gcloud iam service-accounts create vanel-ci-cd --display-name="Vanel CI/CD Service Account"

# Grant Cloud Run and Artifact Registry permissions to the service account
gcloud projects add-iam-policy-binding $PROJECT_ID   --member="serviceAccount:vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com"   --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID   --member="serviceAccount:vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com"   --role="roles/artifactregistry.writer"

# Generate and download the service account key
gcloud iam service-accounts keys create gcp-key.json   --iam-account=vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com

# Encode it to base64 and paste into GitHub secret
cat gcp-key.json | base64
```

---

(…continues with similar explanatory formatting for each command block…)

