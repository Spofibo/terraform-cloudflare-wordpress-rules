# Standard zone configuration settings
resource "cloudflare_zone_settings_override" "this" {
  zone_id = data.cloudflare_zones.this.zones[0].id

  settings {
    # Security
    waf                = var.waf
    security_level     = var.security_level
    email_obfuscation  = var.email_obfuscation
    challenge_ttl      = var.challenge_ttl
    hotlink_protection = var.hotlink_protection

    # Modernization
    http2 = var.http2
    http3 = var.http3

    # Caching
    cache_level = var.cache_level

    # Performance
    brotli      = var.brotli
    early_hints = var.early_hints

    minify {
      css  = var.minify.css
      js   = var.minify.js
      html = var.minify.html
    }

    # SSL/TLS
    ssl                      = var.tls_settings.ssl
    tls_1_3                  = var.tls_settings.tls_1_3
    min_tls_version          = var.tls_settings.min_tls_version
    opportunistic_encryption = var.tls_settings.opportunistic_encryption
    automatic_https_rewrites = var.tls_settings.automatic_https_rewrites
    always_use_https         = var.tls_settings.always_use_https

    security_header {
      enabled            = var.security_header.enabled
      preload            = var.security_header.preload
      include_subdomains = var.security_header.include_subdomains
      nosniff            = var.security_header.nosniff
      max_age            = var.security_header.max_age
    }
  }
}
