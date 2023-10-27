provider "google" {
  project = var.project_id
  region  = var.region
}

variable "project_id" {}
variable "region" {}
variable "service_name" {}
variable "github_owner" {}
variable "github_repo" {}

variable "env_vars" {
  description = "Environment variables"
  type        = map(string)
}

resource "google_cloud_run_service" "default" {
  name     = var.service_name
  location = var.region

  template {
    metadata {
      annotations = {
        "autoscaling.knative.dev/minScale" = "0"
        "autoscaling.knative.dev/maxScale" = "1"
      }
    }

    spec {
      containers {
        image = "gcr.io/${var.project_id}/${var.service_name}"

        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.key
            value = env.value
          }
        }

        ports {
          container_port = 8001
        }

        resources {
          limits = {
            memory = "128Mi"
            cpu    = "1"
          }
        }
      }
      service_account_name  = google_service_account.cloud_run_service_account.email
      container_concurrency = 80
      timeout_seconds       = 300
    }
  }

  autogenerate_revision_name = true
  traffic {
    percent         = 100
    latest_revision = true
  }
}

resource "google_service_account" "cloud_run_service_account" {
  account_id   = "cloud-run-service-account"
  display_name = "Cloud Run Service Account"
}

resource "google_cloudbuild_trigger" "github_trigger" {
  name        = "github-trigger"
  description = "Trigger for GitHub commits"

  github {
    owner = var.github_owner
    name  = var.github_repo
    push {
      branch = "^main$"
    }
  }

  filename = "cloudbuild.yaml"
}
