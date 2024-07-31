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
  }
  
  cloud {
    organization = "aaron-vm-demo"
    workspaces {
      project = "VMware-Project"
      name = "hello-vmware"
    }
  }
}

provider "vault" {
  address = "https://vault.hashicorp.local:8200"
  skip_child_token = true
}