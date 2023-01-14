################################################################
### Setup
################################################################
variable "cf_api_token" {
  description = "value"
  type        = string
}

variable "domain_name" {
  description = "value"
  type        = string
}

variable "redirect_to_www" {
  description = "value"
  type        = bool
  default     = false
}

################################################################
### WAF Rules
################################################################
variable "waf_wpadmin_ip_restricted" {
  description = "Determins if wp-admin is restricted by IP access"
  type        = bool
  default     = false
}

variable "waf_allowed_ip" {
  description = "List of allowed IPs"
  type        = string
  default     = ""
}

variable "waf_wpadmin_country_restricted" {
  description = "Determins if wp-admin is restricted by country access"
  type        = bool
  default     = false
}

variable "waf_allowed_countries" {
  description = "List of allowed countries. i.e.: [\"UK\", \"US\"]"
  type        = list(any)
  default     = []
}

variable "waf_block_other_malicious_calls" {
  description = "Determins if a filter to block other malicious calls is implemented or not"
  type        = bool
  default     = false
}

variable "waf_block_bad_bots" {
  description = "Determins if a filter to block bad bots calls is implemented or not"
  type        = bool
  default     = false
}

################################################################
### Zone Settings
################################################################
variable "hotlink_protection" {
  description = "value"
  type        = string
  default     = "on"
}

variable "challenge_ttl" {
  description = "value"
  type        = string
  default     = 1800
}

variable "security_level" {
  description = "value"
  type        = string
  default     = "medium"
}

variable "http3" {
  description = "https://blog.cloudflare.com/http3-the-past-present-and-future/"
  type        = string
  default     = "on"
}


variable "brotli" {
  description = "https://blog.cloudflare.com/brotli-compression-using-a-reduced-dictionary/"
  type        = string
  default     = "on"
}

variable "email_obfuscation" {
  description = "value"
  type        = string
  default     = "on"
}

variable "cache_level" {
  description = "value"
  type        = string
  default     = "aggressive"
}

variable "early_hints" {
  description = "https://blog.cloudflare.com/early-hints/"
  type        = string
  default     = "on"
}

variable "automatic_https_rewrites" {
  description = "value"
  type        = string
  default     = "on"
}

variable "minify" {
  description = "value"

  type = object({
    css  = string
    js   = string
    html = string
  })

  default = {
    css  = "on"
    js   = "off"
    html = "on"
  }
}

variable "security_header" {
  description = "value"

  type = object({
    enabled            = bool
    preload            = bool
    include_subdomains = bool
    nosniff            = bool
    max_age            = number
  })

  default = {
    enabled            = true
    preload            = true
    include_subdomains = true
    nosniff            = true
    max_age            = 2630000 # 1 month
  }
}

variable "tls_settings" {
  description = "General SSL/TLS settings"

  type = object({
    ssl                      = string
    tls_1_3                  = string
    min_tls_version          = string
    automatic_https_rewrites = string
    opportunistic_encryption = string
    always_use_https         = string
  })

  default = {
    ssl                      = "strict" # https://developers.cloudflare.com/ssl/origin-configuration/ssl-modes
    tls_1_3                  = "on"     # https://developers.cloudflare.com/ssl/edge-certificates/additional-options/tls-13/
    min_tls_version          = "1.2"    # https://developers.cloudflare.com/ssl/edge-certificates/additional-options/minimum-tls/
    automatic_https_rewrites = "on"     # https://developers.cloudflare.com/ssl/edge-certificates/additional-options/automatic-https-rewrites/
    opportunistic_encryption = "on"     # https://developers.cloudflare.com/ssl/edge-certificates/additional-options/opportunistic-encryption/
    always_use_https         = "on"     # https://developers.cloudflare.com/ssl/edge-certificates/additional-options/always-use-https/
  }
}

################################################################
### Argo
################################################################
variable "argo_tiered_caching" {
  description = "Enable or disable Argo tiered caching"
  type        = bool
  default     = false
}