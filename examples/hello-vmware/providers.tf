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
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2"
    }
    nsxt = {
      source  = "vmware/nsxt"
      version = "~> 3"
    }
    boundary = {
      source  = "hashicorp/boundary"
      version = "~> 1"
    }
  }

  cloud {
    organization = ""
    workspaces {
      project = "VMware-Project"
      name    = "hello-vmware"
    }
  }
}

provider "vault" {
  address          = var.vault_address
  skip_child_token = true
}

provider "vsphere" {
  user     = "${data.vault_ldap_static_credentials.vm_builder.username}@hashicorp.local"
  password = data.vault_ldap_static_credentials.vm_builder.password
}

provider "boundary" {
  addr = var.boundary_address
}

provider "hcp" {
}