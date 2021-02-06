terraform {
  required_version = ">= 0.14.5, < 0.15.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.2"
    }
  }
}