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
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1"
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
  address = var.vault_address
  auth_login_oidc {
    role = "systems_engineer"
  }
  skip_child_token = true
}

provider "vsphere" {
  vsphere_server = var.vsphere_server
  user           = "${data.vault_ldap_static_credentials.vm_builder.username}@hashicorp.local"
  password       = data.vault_ldap_static_credentials.vm_builder.password
}

provider "boundary" {
  addr = var.boundary_address
}