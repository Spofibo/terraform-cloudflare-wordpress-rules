# Configure Wordpress specific rules on Cloudflare via Terraform


Confgure WordPress specific performance, redirect (www to non-www, or non-www to www), and WAF (security)

## Credits

* https://www.kazimer.com/how-to-protect-wordpress-with-Cloudflare-firewall-rules/
* https://gridpane.com/blog/cloudflare-firewall-rules-for-securing-wordpress-websites/

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.2 |
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 4.7 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 4.7 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_argo.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/argo) | resource |
| [cloudflare_filter.bad_bots](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/filter) | resource |
| [cloudflare_filter.block_other_malicious_calls](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/filter) | resource |
| [cloudflare_filter.wpadmin_country_restricted](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/filter) | resource |
| [cloudflare_filter.wpadmin_ip_restricted](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/filter) | resource |
| [cloudflare_firewall_rule.block_other_malicious_calls](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule) | resource |
| [cloudflare_firewall_rule.wpadmin_country_restricted](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule) | resource |
| [cloudflare_firewall_rule.wpadmin_ip_restricted](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/firewall_rule) | resource |
| [cloudflare_page_rule.redirect_to_www](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/page_rule) | resource |
| [cloudflare_page_rule.redirect_www_to_root_doman](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/page_rule) | resource |
| [cloudflare_zone_settings_override.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zone_settings_override) | resource |
| [cloudflare_zones.this](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_argo_tiered_caching"></a> [argo\_tiered\_caching](#input\_argo\_tiered\_caching) | Enable or disable Argo tiered caching | `bool` | `false` | no |
| <a name="input_automatic_https_rewrites"></a> [automatic\_https\_rewrites](#input\_automatic\_https\_rewrites) | value | `string` | `"on"` | no |
| <a name="input_brotli"></a> [brotli](#input\_brotli) | https://blog.cloudflare.com/brotli-compression-using-a-reduced-dictionary/ | `string` | `"on"` | no |
| <a name="input_cache_level"></a> [cache\_level](#input\_cache\_level) | value | `string` | `"aggressive"` | no |
| <a name="input_cf_api_token"></a> [cf\_api\_token](#input\_cf\_api\_token) | value | `string` | n/a | yes |
| <a name="input_challenge_ttl"></a> [challenge\_ttl](#input\_challenge\_ttl) | value | `string` | `1800` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | value | `string` | n/a | yes |
| <a name="input_early_hints"></a> [early\_hints](#input\_early\_hints) | https://blog.cloudflare.com/early-hints/ | `string` | `"on"` | no |
| <a name="input_email_obfuscation"></a> [email\_obfuscation](#input\_email\_obfuscation) | value | `string` | `"on"` | no |
| <a name="input_hotlink_protection"></a> [hotlink\_protection](#input\_hotlink\_protection) | value | `string` | `"on"` | no |
| <a name="input_http3"></a> [http3](#input\_http3) | https://blog.cloudflare.com/http3-the-past-present-and-future/ | `string` | `"on"` | no |
| <a name="input_minify"></a> [minify](#input\_minify) | value | <pre>object({<br>    css  = string<br>    js   = string<br>    html = string<br>  })</pre> | <pre>{<br>  "css": "on",<br>  "html": "on",<br>  "js": "off"<br>}</pre> | no |
| <a name="input_redirect_to_www"></a> [redirect\_to\_www](#input\_redirect\_to\_www) | value | `bool` | `false` | no |
| <a name="input_security_header"></a> [security\_header](#input\_security\_header) | value | <pre>object({<br>    enabled            = bool<br>    preload            = bool<br>    include_subdomains = bool<br>    nosniff            = bool<br>    max_age            = number<br>  })</pre> | <pre>{<br>  "enabled": true,<br>  "include_subdomains": true,<br>  "max_age": 2630000,<br>  "nosniff": true,<br>  "preload": true<br>}</pre> | no |
| <a name="input_security_level"></a> [security\_level](#input\_security\_level) | value | `string` | `"medium"` | no |
| <a name="input_tls_settings"></a> [tls\_settings](#input\_tls\_settings) | General SSL/TLS settings | <pre>object({<br>    ssl                      = string<br>    tls_1_3                  = string<br>    min_tls_version          = string<br>    automatic_https_rewrites = string<br>    opportunistic_encryption = string<br>    always_use_https         = string<br>  })</pre> | <pre>{<br>  "always_use_https": "on",<br>  "automatic_https_rewrites": "on",<br>  "min_tls_version": "1.2",<br>  "opportunistic_encryption": "on",<br>  "ssl": "strict",<br>  "tls_1_3": "on"<br>}</pre> | no |
| <a name="input_waf_allowed_countries"></a> [waf\_allowed\_countries](#input\_waf\_allowed\_countries) | List of allowed countries. i.e.: ["UK", "US"] | `list(any)` | `[]` | no |
| <a name="input_waf_allowed_ip"></a> [waf\_allowed\_ip](#input\_waf\_allowed\_ip) | List of allowed IPs | `string` | `""` | no |
| <a name="input_waf_block_bad_bots"></a> [waf\_block\_bad\_bots](#input\_waf\_block\_bad\_bots) | Determins if a filter to block bad bots calls is implemented or not | `bool` | `false` | no |
| <a name="input_waf_block_other_malicious_calls"></a> [waf\_block\_other\_malicious\_calls](#input\_waf\_block\_other\_malicious\_calls) | Determins if a filter to block other malicious calls is implemented or not | `bool` | `false` | no |
| <a name="input_waf_wpadmin_country_restricted"></a> [waf\_wpadmin\_country\_restricted](#input\_waf\_wpadmin\_country\_restricted) | Determins if wp-admin is restricted by country access | `bool` | `false` | no |
| <a name="input_waf_wpadmin_ip_restricted"></a> [waf\_wpadmin\_ip\_restricted](#input\_waf\_wpadmin\_ip\_restricted) | Determins if wp-admin is restricted by IP access | `bool` | `false` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->