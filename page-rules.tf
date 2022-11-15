# Rule to redirect to www subdomain
resource "cloudflare_page_rule" "redirect_to_www" {
  count    = var.redirect_to_www ? 1 : 0
  priority = 1
  target   = "${var.domain_name}/*"
  zone_id  = data.cloudflare_zones.this.zones[0].id

  actions {
    forwarding_url {
      status_code = 301
      url         = "https://www.${var.domain_name}/$1"
    }
  }
}

# Rule to redirect www to root domain
resource "cloudflare_page_rule" "redirect_www_to_root_doman" {
  count    = var.redirect_to_www ? 0 : 1
  priority = 1
  target   = "www.${var.domain_name}/*"
  zone_id  = data.cloudflare_zones.this.zones[0].id

  actions {
    forwarding_url {
      status_code = 301
      url         = "https://${var.domain_name}/$1"
    }
  }
}
