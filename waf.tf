################################################################
### Filters
################################################################
resource "cloudflare_filter" "wpadmin_ip_restricted" {
  count       = var.waf_wpadmin_ip_restricted ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Allow access to WordPress admin only for a whitelisted IP address"
  expression  = <<EOF
  (
    (http.request.uri.path contains "/wp-login.php") or
    (http.request.uri.path contains "/wp-admin/" and not http.request.uri.path contains "/wp-admin/admin-ajax.php" and not http.request.uri.path contains "/wp-admin/theme-editor.php")
) and ip.src ne ${var.waf_allowed_ip}
EOF
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

resource "cloudflare_filter" "bad_bots" {
  count       = var.waf_block_bad_bots ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Filter other malicious calls to WordPress"
  #   expression  = <<EOF
  # (http.user_agent contains "${") or 
  # EOF
  expression = <<EOF
(http.user_agent contains "?%00") or 
(http.user_agent contains "$[") or 
(http.user_agent contains "absinthe") or 
(http.user_agent contains "AhrefsBot") or 
(http.user_agent contains "ALittle") or 
(http.user_agent contains "baidu") or 
(http.user_agent contains "BFAC") or 
(http.user_agent contains "/bin/bash") or 
(http.user_agent contains "brutus") or 
(http.user_agent contains "bsqlbf") or 
(lower(http.user_agent) contains "curl") or 
(http.user_agent contains "coccocbot") or 
(http.user_agent contains "commix") or 
(http.user_agent contains "crimscanner") or 
(http.user_agent contains "DavClnt") or 
(http.user_agent contains "datacha0s") or 
(http.user_agent contains "dirbuster") or 
(http.user_agent contains "DnyzBot") or 
(http.user_agent contains "domino") or 
(http.user_agent contains "DotBot") or 
(http.user_agent contains "dotdotpwn") or 
(http.user_agent contains "dragostea") or 
(http.user_agent contains "eval(") or 
(http.user_agent contains "env:") or 
(http.user_agent contains "fhscan") or 
(http.user_agent contains "floodgate") or 
(lower(http.user_agent) contains "fuzz") or 
(http.user_agent contains "get-minimal") or 
(http.user_agent contains "gobuster") or 
(http.user_agent contains "gootkit") or 
(http.user_agent contains "grabber") or 
(http.user_agent contains "grendel") or 
(http.user_agent contains "GRequest") or 
(http.user_agent contains "eadless") or 
(http.user_agent contains "havij") or 
(http.user_agent contains "Hello") or 
(http.user_agent contains "http-client") or 
(http.user_agent contains "hydra") or 
(http.user_agent contains "jdni") or 
(http.user_agent contains "Jorgee") or 
(http.user_agent contains "nowledge") or 
(http.user_agent contains "ldap") or 
(http.user_agent contains "lobster") or 
(http.user_agent contains "Lua") or 
(http.user_agent contains "lx71") or 
(http.user_agent contains "masscan") or 
(http.user_agent contains "mail.ru") or 
(http.user_agent contains "mea pentru") or 
(http.user_agent contains "metis") or 
(http.user_agent contains "Protocol Discovery") or 
(http.user_agent contains "morfeus") or 
(http.user_agent contains "mysqloit") or 
(http.user_agent contains "My User Agent") or 
(http.user_agent contains "nasl") or 
(http.user_agent contains "NetSystemsResearch") or 
(http.user_agent contains "Nikto") or 
(http.user_agent contains "Nimbostratus") or 
(http.user_agent contains "nmap") or 
(http.user_agent contains "Nuclei") or 
(http.user_agent contains "openvas") or 
(http.user_agent contains "pangolin") or 
(http.user_agent contains "PetalBot") or 
(http.user_agent contains "plesk") or 
(lower(http.user_agent) contains "python") or 
(http.user_agent contains "QQGameHall") or 
(http.user_agent contains "ReactorNetty") or 
(http.user_agent contains "RestSharp") or 
(http.user_agent contains "revolt") or 
(http.user_agent contains "Scrapy") or 
(http.user_agent contains "SeznamBot") or 
(http.user_agent contains "Sogou") or 
(http.user_agent contains "spbot") or 
(http.user_agent contains "springenwerk") or 
(http.user_agent contains "sqlmap") or 
(http.user_agent contains "sqlninja") or 
(http.user_agent contains "Uptimebot") or 
(http.user_agent contains "vega/") or 
(http.user_agent contains "w3af") or 
(http.user_agent contains "WebDAV-MiniRedir") or 
(http.user_agent contains "webshag") or 
(http.user_agent contains "WinHttp.WinHttpRequest") or 
(http.user_agent contains "wp_is_mobile") or 
(http.user_agent contains "YandexBot") or 
(lower(http.user_agent) contains "zmeu")
EOF
}

################################################################
### Rules linked to filters
################################################################
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