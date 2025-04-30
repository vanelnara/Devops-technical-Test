
No matching results, press enter to execute your custom prompt paraphrase these text
# Vanel's DevOps Technical Test Solution 

This project showcases a comprehensive DevOps pipeline for deploying a containerized **PHP** web application (utilizing **Nginx** as a reverse proxy) on **Google Cloud Run**. The application integrates with a Cloud SQL (**MySQL**) database and employs **Cloud Storage** for hosting static files. Infrastructure is controlled through Terraform (Infrastructure-as-Code), while the build and deployment processes are automated with **GitHub Actions** (CI/CD pipeline) and helpful **Bash** scripts.

---

## Repository Structure 

```├── .github/
│   └── workflows/
│       └── deploy.yml
├── infrastructure/
│   ├── modules/
│   │   └── cloud_sql/
│   │       ├── main.tf
│   │       ├── outputs.tf
│   │       └── variables.tf
│   ├── main.tf
│   ├── outputs.tf
│   ├── variables.tf
│   └── terraform.tfvars.example
├── src/
│   ├── nginx/
│   │   └── default.conf
│   ├── php/
│   │   └── index.php
│   └── Dockerfile
├── scripts/
│   └── get_cloudrun_ip.sh
├── README.md
├── dr.md
└── extra.md
```

---

## 📌 Project Summary

A **PHP web application** hosted on **Google Cloud Run**, featuring:

- **Cloud SQL MySQL** database  
- **Cloud Storage** for static content  
- **Automated CI/CD pipeline** using GitHub Actions  
- **Infrastructure as Code** with **Terraform**

---

## 📖 Comprehensive Deployment Instructions

### ✅ Requirements

#### Google Cloud Account:
- Sign up: [https://cloud.google.com](https://cloud.google.com)
- Activate billing (free tier available)

#### Install Cloud SDK:
```bash
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```

#### Terraform Setup:
```bash
# Linux installation
wget https://releases.hashicorp.com/terraform/1.5.0/terraform_1.5.0_linux_amd64.zip
unzip terraform_1.5.0_linux_amd64.zip
sudo mv terraform /usr/local/bin/
terraform --version
```

#### GitHub Account:
- Sign up: [https://github.com](https://github.com)

#### Configure SSH keys:
```bash
ssh-keygen -t ed25519 -C "vanel@example.com"
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_ed25519
```

---

## 🚀 Steps for Deployment

### 1. Terraform Configuration and Deployment

```bash
# Clone the repository
git clone https://github.com/vanel/devops-solution.git
cd devops-solution/infrastructure

# Set up terraform.tfvars
cp terraform.tfvars.example terraform.tfvars
nano terraform.tfvars
```

Example of `terraform.tfvars`:
```hcl
project_id  = "vanel-gcp-project"
region      = "europe-west3"
db_name     = "vanel_app_db"
db_user     = "vanel_admin"
db_pass     = "SecurePassword123!"
environment = "production"
```

```bash
terraform init
terraform plan
terraform apply
```

To remove later:
```bash
terraform destroy
```
---

## 2. Running the CI/CD Workflow (GitHub Actions)

Once you have committed your code and configured your GitHub repository secrets, every push to the `main` branch will automatically trigger the CI/CD pipeline.

This pipeline will:
1. Authenticate with Google Cloud using your service account.
2. Build the Docker image from the provided `Dockerfile`.
3. Push the image to Google Container Registry (GCR).
4. Deploy the new image to your Cloud Run service.

### ✅ Steps to Trigger CI/CD

```bash
# Stage all changes
git add .

# Commit your changes
git commit -m "Add initial deployment configuration"

# Push to the main branch to trigger deployment
git push origin main
```

To monitor the workflow:
- Go to your repository on GitHub.
- Click on the **"Actions"** tab.
- Select the latest workflow run to see logs and status.

---

---

### 3. Configuring GitHub Secrets

Navigate to `Settings > Secrets > Actions` and add:

- `VANEL_GCP_PROJECT`  
- `VANEL_GCP_SA_KEY`

Commands:
```bash
gcloud config get-value project

gcloud iam service-accounts create vanel-ci-cd --display-name="Vanel CI/CD Service Account"

gcloud projects add-iam-policy-binding $PROJECT_ID   --member="serviceAccount:vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com"   --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID   --member="serviceAccount:vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com"   --role="roles/artifactregistry.writer"

gcloud iam service-accounts keys create gcp-key.json   --iam-account=vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com

cat gcp-key.json | base64
```

---

## 🔐 Security Enhancements

### 1. Database Security Measures

```bash
gcloud sql instances patch vanel-mysql-prod   --assign-ip   --no-assign-ip   --network=default

gcloud sql ssl server-ca-certs list --instance=vanel-mysql-prod

gcloud sql users set-password vanel_admin   --instance=vanel-mysql-prod   --password=NewSecurePassword456!

gcloud sql instances patch vanel-mysql-prod   --backup-start-time=02:00   --enable-bin-log
```

---

### 2. Least Privilege IAM Practices

```bash
gcloud iam roles create VanelDevOpsRole   --project=$PROJECT_ID   --title="Vanel DevOps Custom Role"   --description="Custom role with minimum required permissions"   --permissions=cloudsql.instances.connect,cloudsql.instances.get,run.services.create,run.services.update,storage.buckets.create

gcloud projects add-iam-policy-binding $PROJECT_ID   --member="serviceAccount:vanel-ci-cd@${PROJECT_ID}.iam.gserviceaccount.com"   --role="projects/${PROJECT_ID}/roles/VanelDevOpsRole"
```

---

### 3. Secret Management through Google Secret Manager

```bash
echo -n "SecurePassword123!" | gcloud secrets create vanel-db-password --data-file=- --replication-policy=automatic

gcloud secrets add-iam-policy-binding vanel-db-password   --member="serviceAccount:${PROJECT_NUMBER}-compute@developer.gserviceaccount.com"   --role="roles/secretmanager.secretAccessor"
```

---

## ⚙️ Production Optimization Strategies

### 1. Resource Configuration

```bash
gcloud run services update vanel-web-app-prod   --region=europe-west3   --cpu=2   --memory=2Gi   --max-instances=5   --concurrency=80   --timeout=300s

gcloud sql instances patch vanel-mysql-prod   --tier=db-custom-2-4096   --storage-size=50GB   --storage-auto-increase
```

---

### 2. Monitoring and Alert Systems

Create a `monitoring-policy.json` file, then execute:
```bash
gcloud alpha monitoring policies create --policy-from-file=monitoring-policy.json
```

---

## 📈 Configuration for Auto-Scaling

```bash
gcloud run services update vanel-web-app-prod   --region=europe-west3   --min-instances=1   --max-instances=10   --cpu-throttling   --execution-environment=gen2

gcloud run services update-traffic vanel-web-app-prod   --region=europe-west3   --to-revisions=LATEST=100   --
```

---

## 🛠 Challenges Faced During Implementation & Solutions

### 1. Terraform State Locking Issues
**Error:**
```
Error acquiring the state lock: writing "gs://.../default.tflock" failed: Error 412: Precondition Failed
```

**Solution:**
```bash
terraform force-unlock <LOCK_ID>
```
Or use Terraform Cloud for remote state:
```hcl
terraform {
  backend "remote" {
    organization = "vanel-org"
    workspaces {
      name = "gcp-deployment"
    }
  }
}
```

---

### 2. Cloud SQL Private IP Connectivity Problems

**Error:**
```
PDOException: SQLSTATE[HY000] [2002] Connection timed out
```

**Solution:**
```bash
gcloud compute networks vpc-access connectors create vanel-connector   --region=europe-west3   --subnet=default
```

Add to Terraform annotations:
```hcl
"run.googleapis.com/vpc-access-connector" = "vanel-connector"
```

---

### 3. GitHub Actions Docker Push Failures

**Error:**
```
denied: Permission "artifactregistry.repositories.downloadArtifacts" denied
```

**Solution:**
```bash
gcloud projects add-iam-policy-binding $PROJECT_ID   --member="serviceAccount:vanel-ci-cd@..."   --role="roles/artifactregistry.writer"
```

In GitHub Actions:
```yaml
- name: Push to GCR
  run: |
    gcloud auth configure-docker
    docker push gcr.io/$PROJECT_ID/vanel-web-app:$GITHUB_SHA
```

---

### 4. Cold Starts & High Latency in Cloud Run

**Solution:**
```bash
gcloud run deploy vanel-web-app-prod --min-instances=1 --region=europe-west3
```

Optimize Dockerfile:
```dockerfile
FROM php:8.2-fpm-alpine
RUN apk add --no-cache nginx mysql-client
```

---

### 5. Exposed DB Credentials in Terraform

**Solution:**
```bash
echo -n "MySecurePassword123!" | gcloud secrets create vanel-db-password --data-file=-
```

Reference in Terraform:
```hcl
data "google_secret_manager_secret_version" "db_password" {
  secret = "vanel-db-password"
}

resource "google_sql_user" "vanel_db_user" {
  password = data.google_secret_manager_secret_version.db_password.secret_data
}
```

---

### 6. Nginx + PHP-FPM 502 Errors

**Error:**
```
connect() failed (111: Connection refused) while connecting to upstream
```

**Fix:**
In PHP:
```ini
listen = 127.0.0.1:9000
listen.allowed_clients = 127.0.0.1
```

In Nginx:
```nginx
location ~ \.php$ {
  fastcgi_pass   127.0.0.1:9000;
  include        fastcgi_params;
}
```

---

## 🌐 Official Documentation Links

- [Cloud Run Docs](https://cloud.google.com/run/docs)  
- [Cloud SQL Docs](https://cloud.google.com/sql/docs/mysql)  
- [Cloud Storage Docs](https://cloud.google.com/storage/docs)  
- [IAM Best Practices](https://cloud.google.com/iam/docs/best-practices)  
- [Terraform GCP Provider](https://registry.terraform.io/providers/hashicorp/google/latest/docs)  
- [Terraform Modules](https://developer.hashicorp.com/terraform/language/modules)  
- [Terraform State](https://developer.hashicorp.com/terraform/language/state)  
- [GitHub Actions Guide](https://docs.github.com/en/actions/learn-github-actions)  
- [Secret Manager Docs](https://cloud.google.com/secret-manager/docs)  
- [Cloud SQL Private IP](https://cloud.google.com/sql/docs/mysql/private-ip)  
- [Cloud Run Security](https://cloud.google.com/run/docs/securing)  
- [Autoscaling Docs](https://cloud.google.com/run/docs/about-auto-scaling)  
- [PHP-FPM Tuning](https://www.nginx.com/resources/wiki/start/topics/examples/phpfcgi/)  

---

**Created with ❤️ by Vanel**
