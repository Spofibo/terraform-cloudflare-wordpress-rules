terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cf_api_token
}

data "cloudflare_zones" "this" {
  filter {
    name        = var.domain_name
    lookup_type = "contains"
    status      = "active"
    paused      = false
  }
}
