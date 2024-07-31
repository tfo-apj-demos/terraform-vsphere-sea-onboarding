terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0"
    }
    vault = {
      source  = "hashicorp/vault"
      version = "~> 4"
    }
    tfe = {
      source  = "hashicorp/tfe"
      version = "~> 0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2"
    }
    nsxt = {
      source  = "vmware/nsxt"
      version = "~> 3"
    }
  }
}

provider "tfe" {
  organization = var.tfc_organization_name
}

provider "hcp" {
  client_id     = data.vault_kv_secret_v2.this.data.client_id
  client_secret = data.vault_kv_secret_v2.this.data.client_secret
}

provider "vault" {
  skip_child_token = true
}

provider "vsphere" {
  user           = "${data.vault_ldap_static_credentials.vm_builder.username}@hashicorp.local"
  password       = data.vault_ldap_static_credentials.vm_builder.password
  vsphere_server = "vcsa-98975.fe9dbbb3.asia-southeast1.gve.goog"
}

provider "nsxt" {
  username = "${data.vault_ldap_static_credentials.nsx_read_only.username}@hashicorp.local"
  password = data.vault_ldap_static_credentials.nsx_read_only.password
  host     = "nsx-98984.fe9dbbb3.asia-southeast1.gve.goog"
}