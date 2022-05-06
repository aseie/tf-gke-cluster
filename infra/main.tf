# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/google_project_service
resource "google_project_service" "compute" {
  service = "compute.googleapis.com"
  disable_dependent_services = true
}

resource "google_project_service" "container" {
  service = "container.googleapis.com"
}


module "helm_charts" {
  count = var.helm_deploy_enabled ? 1 : 0

  source = "./modules/helm-charts"

  project_id                     = var.provider_project_id
  subnetwork                     = local.network.gke_subnet_name
  cert_manager_issuer_email      = var.helm_cert_manager_issuer_email
  global_resource_prefix         = local.global_resource_prefix
  external_nginx_ingress_enabled = var.helm_external_nginx_ingress_enabled
  internal_nginx_ingress_enabled = var.helm_internal_nginx_ingress_enabled

  # depends_on = [module.openvpn[0]]
}
