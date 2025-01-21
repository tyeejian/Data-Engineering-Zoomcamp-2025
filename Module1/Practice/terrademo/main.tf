terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  credentials = "./keys/my-creds.json"
  project     = "solid-authority-448207-q6"
  region      = "us-central1"
}

resource "google_storage_bucket" "demo-bucket" {
  name          = "olid-authority-448207-q6-terra-bucket"
  location      = "US"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}