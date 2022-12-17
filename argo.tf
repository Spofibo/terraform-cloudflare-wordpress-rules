resource "cloudflare_argo" "this" {
  zone_id        = data.cloudflare_zones.this.zones[0].id
  tiered_caching = var.argo_tiered_caching ? "on" : "off"
}