data "cloudflare_zones" "this" {
  filter {
    name        = var.domain_name
    lookup_type = "contains"
    status      = "active"
    paused      = false
  }
}
