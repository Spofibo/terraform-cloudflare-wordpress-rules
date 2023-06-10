terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4.7"
    }

    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.2"
    }
  }
}

provider "cloudflare" {
  api_token = var.cf_api_token
}
