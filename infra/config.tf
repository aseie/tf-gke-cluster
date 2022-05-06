# https://registry.terraform.io/providers/hashicorp/google/latest/docs
provider "google" {
  project = var.provider_project_id
  region  = var.region
}

provider "kubernetes" {
  cluster_ca_certificate = base64decode(module.kubernetes-engine.ca_certificate)
  token                  = data.google_client_config.default.access_token
  host                   = "https://${module.kubernetes-engine.endpoint}"
}

provider "kubectl" {
  cluster_ca_certificate = base64decode(module.kubernetes-engine.ca_certificate)
  token                  = data.google_client_config.default.access_token
  host                   = "https://${module.kubernetes-engine.endpoint}"
}

provider "helm" {
  kubernetes {
    cluster_ca_certificate = base64decode(module.kubernetes-engine.ca_certificate)
    token                  = data.google_client_config.default.access_token
    host                   = "https://${module.kubernetes-engine.endpoint}"
  }
}

# https://www.terraform.io/language/settings/backends/gcs
terraform {
  backend "gcs" {
    # bucket = "adriano-seie-labs-tfstate-bucket"
    bucket = "gke-terraform-state-bucket"
    prefix = "terraform/tf-gke-cluster/state"
  }
}
