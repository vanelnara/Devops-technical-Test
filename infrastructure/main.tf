terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  backend "gcs" {
    bucket = "vanel-devops-tf-state"
    prefix = "prod/website"
  }
}
provider "google" {
  project = var.project_id
  region  = var.region
}
module "vanel_cloud_sql" {
  source     = "./modules/cloud_sql"
  project_id = var.project_id
  region     = var.region
  db_name    = var.db_name
  db_user    = var.db_user
  db_pass    = var.db_pass
}
resource "google_storage_bucket" "vanel_static_assets" {
  name = "vanel-website-assets-${var.environment}"
  location = var.region
  storage_class = "STANDARD"
  uniform_bucket_level_access = true
}
resource "google_cloud_run_service" "vanel_web_app" {
  name     = "vanel-web-app-${var.environment}"
  location = var.region
  template {
    spec {
      containers {
        image = "gcr.io/${var.project_id}/vanel-web-app:${var.image_tag}"
        env { name = "DB_HOST" value = module.vanel_cloud_sql.db_private_ip }
        env { name = "DB_NAME" value = var.db_name }
        env { name = "DB_USER" value = var.db_user }
        env { name = "DB_PASS" value = var.db_pass }
        env { name = "ENVIRONMENT" value = var.environment }
      }
      container_concurrency = 80
      timeout_seconds = 300
    }
  }
  traffic {
    percent = 100
    latest_revision = true
  }
}
