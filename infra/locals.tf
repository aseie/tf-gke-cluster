locals {
    common_tags = {
        env               = var.env
        owner             = var.owner
        project_id        = var.provider_project_id
        region            = var.region
  }
    global_resource_prefix = "${var.env}-${var.prefix}"

    service = {
        application = "devops"
    }
    network = {
        gke_subnet_name = "${local.global_resource_prefix}-gke-${var.region}-subnet"
        db_subnet_name  = "${local.global_resource_prefix}-db-${var.region}-subnet"
        subnet_cidrs = {
            gke          = "100.64.0.0/20"
            gke_services = "100.64.48.0/20"
            gke_pods     = "100.64.96.0/20"
            }
    
    }

    dns = {
        cloud_dns_zone_domains = [ "adriano-labs.seie.local" ]
    }

    gke = {
        cluster_name    = "${local.global_resource_prefix}-cluster"
        gke_pods       = "${local.network.gke_subnet_name}-pods"
        gke_services    = "${local.network.gke_subnet_name}-services"
        gke_cluster_autoscaling = {
            enabled       = true
            min_cpu_cores = 1
            min_memory_gb = 2
            max_cpu_cores = 4
            max_memory_gb = 6
            gpu_resources = []
        }
        gke_node_pools = [
        {
            name                        = "core"
            machine_type                = "e2-small"
            # machine_type                = "n1-custom-2-2048"
            preemptible                 = true
            disk_type                   = "pd-standard"
            disk_size_gb                = 80
            autoscaling                 = true
            auto_repair                 = true
            sandbox_enabled             = false
            cpu_manager_policy          = "static"
            cpu_cfs_quota               = true
            enable_integrity_monitoring = true
            enable_secure_boot          = true
            image_type                  = "COS_CONTAINERD"

        },
    ]
    }

    openvpn_users = [
        "devops",
        "lab"
    ]
}       