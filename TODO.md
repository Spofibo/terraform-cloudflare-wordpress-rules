- [ ] Option to add personal ip to Cloudflare whitelist
- [ ] Option to block xmlrpc
```
resource "cloudflare_filter" "block_xmlrpc" {
  count       = var.waf_block_xmlrcp ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "Block all access to xmlrc"
  expression = "(http.request.uri.path contains "/xmlrpc.php")"
}
```

- [ ] Option to block hotlinking
```
resource "cloudflare_filter" "forbid_outside_access_to_files" {
  count       = var.waf_forbid_outside_access_to_files ? 1 : 0
  zone_id     = data.cloudflare_zones.this.zones[0].id
  description = "This rule will block any outside access to files inside wp-content and wp-includes. Useful for preventing hotlinking"
  expression = <<EOF
  (http.request.uri.path contains "/wp-content/" and not http.referer contains "${var.domain_name}") or (http.request.uri.path contains "/wp-includes/" and not http.referer contains "${var.domain_name}")
EOF
}
```

- [ ] Prevent comment spam -> `wp-comments-post.php`
```
  (http.request.uri.path eq "/wp-comments-post.php" and http.request.method eq "POST" and not http.referer contains "yoursite.com")
```
OR
```
(http.request.uri contains "/wp-admin/admin-ajax.php" and http.request.method eq "POST" and not http.referer contains "yourwebsitehere.com") or (http.request.uri contains "/wp-comments-post.php" and http.request.method eq "POST" and not http.referer contains "yourwebsitehere.com")
```

- [ ] Option to block No-Referer Requests to Plugins

Legitimate requests which come through your website have something along the lines of ”http://yoursite.com/page” as the HTTP referer and should be allowed. You may also want to allow known good bots (such as the Google crawler) just in case they try to index something—such as an image—inside your plugins folder.

```
  (http.request.uri.path contains "/wp-content/plugins/" and not http.referer contains "yoursite.com" and not cf.client.bot)
```