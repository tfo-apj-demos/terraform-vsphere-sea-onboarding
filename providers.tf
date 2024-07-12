terraform {
  required_providers {
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0"
    }
    nsxt = {
      source  = "vmware/nsxt"
      version = "~> 3"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2"
    }
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0"
    }
  }
}

provider "tfe" {
  organization = var.tfc_organization_name
}

provider "hcp" {
  client_id = data.vault_kv_secret_v2.this.data.client_id
  client_secret = data.vault_kv_secret_v2.this.data.client_secret
}