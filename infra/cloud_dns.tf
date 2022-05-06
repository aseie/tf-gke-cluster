resource "google_dns_managed_zone" "domains" {
    for_each = toset(local.dns.cloud_dns_zone_domains)

    name     = replace(each.value, ".", "-")
    dns_name = "${each.value}."
    dnssec_config {
        state = "on"
    }
    description = "DNS zone for ${each.value}"
}
