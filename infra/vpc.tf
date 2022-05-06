module "network" {
  source  = "registry.terraform.io/terraform-google-modules/network/google"
  version = "4.0.1"

  network_name                           = "${local.global_resource_prefix}-vpc"
  project_id                             = var.provider_project_id
  auto_create_subnetworks                = false
  delete_default_internet_gateway_routes = false
  mtu                                    = 1460

  subnets = [
    {
      subnet_name           = local.network.gke_subnet_name
      subnet_ip             = local.network.subnet_cidrs.gke
      subnet_region         = var.region
      subnet_private_access = "true"
      subnet_flow_logs      = "true"
    }
  ]

  secondary_ranges = {
    (local.network.gke_subnet_name) = [
      {
        range_name    = local.gke.gke_pods
        ip_cidr_range = local.network.subnet_cidrs.gke_pods
      },
      {
        range_name    = local.gke.gke_services
        ip_cidr_range = local.network.subnet_cidrs.gke_services
      }
    ]
  }

  firewall_rules = [
    {
      name        = "${local.global_resource_prefix}-internal-internal-all-all-allow-rule"
      description = "Allow internal inter-subnet communication."
      direction   = "INGRESS"
      ranges = [
        local.network.subnet_cidrs.gke,
        local.network.subnet_cidrs.gke_services,
        local.network.subnet_cidrs.gke_pods,
      ]
      priority = 65534
      allow = [
        {
          protocol = "tcp",
          ports    = ["0-65535"]
        },
        {
          protocol = "udp",
          ports    = ["0-65535"]
        },
        {
          protocol = "icmp",
          ports    = []
        },
      ]
    }
  ]
}

resource "google_compute_router" "this" {
  count = var.cloudnat_enabled ? 1 : 0

  project = var.provider_project_id
  name    = "${local.global_resource_prefix}-nat-router"
  network = module.network.network_name
  region  = var.region
}

module "cloud-nat" {
  count = var.cloudnat_enabled ? 1 : 0

  source  = "registry.terraform.io/terraform-google-modules/cloud-nat/google"
  version = "~> 2.0.0"

  project_id                         = var.provider_project_id
  region                             = var.region
  router                             = google_compute_router.this[0].name
  name                               = "${local.global_resource_prefix}-nat-config"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
