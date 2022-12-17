### Filters
resource "cloudflare_filter" "wpadmin_ip_restricted" {
  count       = var.waf_wpadmin_ip_restricted ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Allow access to WordPress admin only for a whitelisted IP address"
  expression  = "(http.request.uri.path  \".*wp-login.php\" or http.request.uri.path ~ \".*xmlrpc.php\") and ip.src ne ${var.waf_allowed_ip}"
}

resource "cloudflare_filter" "wpadmin_country_restricted" {
  count       = var.waf_wpadmin_country_restricted ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Allow access to WordPress admin only for whitelisted countries"
  expression  = <<EOF
  (
    (http.request.uri.path contains "/wp-login.php") or
    (http.request.uri.path contains "/wp-admin/" and not http.request.uri.path contains "/wp-admin/admin-ajax.php" and not http.request.uri.path contains "/wp-admin/theme-editor.php")
) and not ip.geoip.country in {${"${join(" ", [for s in var.waf_allowed_countries : format("%q", s)])}"}}
EOF
}

resource "cloudflare_filter" "block_other_malicious_calls" {
  count       = var.waf_block_other_malicious_calls ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Filter other malicious calls to WordPress"
  expression  = <<EOF
(cf.threat_score gt 14) or 
(http.request.uri.query contains "author_name=") or 
(http.request.uri.query contains "author=" and not http.request.uri.path contains "/wp-admin/export.php") or 
(http.request.uri contains "/wp-json/wp/v2/users/") or 
(http.request.uri contains "wp-config.") or (http.request.uri contains "setup-config.") or 
(http.request.uri.path contains "/wp-content/" and http.request.uri.path contains ".php") or 
(http.request.uri.path contains ".js.map") or 
(lower(http.request.uri.path) contains "phpmyadmin") or 
(lower(http.request.uri.path) contains "thinkphp") or 
(lower(http.request.uri.path) contains "/phpunit") or 
(raw.http.request.uri contains "../") or (raw.http.request.uri contains "..%2F") or 
(http.request.uri contains "passwd") or 
(http.request.uri contains "/var/log/") or 
(http.request.uri contains "/dfs/") or 
(http.request.uri contains "/autodiscover/") or 
(http.request.uri contains "/wpad.") or 
(http.request.uri contains "wallet.dat") or 
(http.request.uri contains "webconfig") or 
(http.request.uri contains "vuln.") or 
(http.request.uri contains ".sql") or (http.request.uri contains ".bak") or (http.request.uri contains ".cfg") or (http.request.uri contains ".env") or (http.request.uri contains ".ini") or (http.request.uri contains ".log") or 
(http.request.uri.query contains "bin.com/") or (http.request.uri.query contains "bin.net/") or (raw.http.request.uri.query contains "?%00") or 
(http.request.uri.query contains "eval(") or (http.request.uri.query contains "base64") or (http.request.uri.query contains "var_dump") or 
(http.request.uri.query contains "<script") or (raw.http.request.uri.query contains "%3Cscript") or 
(http.request.uri contains "<?php") or 
(http.cookie contains "<?php") or 
(http.cookie contains "<script") or (http.referer contains "%3Cscript") or 
(http.cookie contains"() {") or (http.cookie contains "base64") or (http.cookie contains "var_dump") or 
(upper(http.request.uri.query) contains "$_GLOBALS[") or 
(upper(http.request.uri.query) contains "$_REQUEST[") or 
(upper(http.request.uri.query) contains "$_POST[")
EOF
}

### Rules with filters
resource "cloudflare_firewall_rule" "wpadmin_ip_restricted" {
  count       = var.waf_wpadmin_ip_restricted ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Allow wp-admin access to an IP address"
  filter_id   = cloudflare_filter.wpadmin_ip_restricted[0].id
  action      = "block"
}

resource "cloudflare_firewall_rule" "wpadmin_country_restricted" {
  count       = var.waf_wpadmin_country_restricted ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Allow wp-admin access to certain countries"
  filter_id   = cloudflare_filter.wpadmin_country_restricted[0].id
  action      = "block"
}

resource "cloudflare_firewall_rule" "block_other_malicious_calls" {
  count       = var.waf_block_other_malicious_calls ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Block other malicious calls"
  filter_id   = cloudflare_filter.block_other_malicious_calls[0].id
  action      = "block"
}