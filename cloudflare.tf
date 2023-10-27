terraform {
  required_providers {
    cloudflare = {
      source = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }
}

variable "api_token" {}
variable "zone_id" {}
variable "account_id" {}

provider "cloudflare" {
  api_token = var.api_token
}

resource "cloudflare_r2_bucket" "example" {
  account_id = var.account_id
  name       = "terraform-test-bucket"
}
