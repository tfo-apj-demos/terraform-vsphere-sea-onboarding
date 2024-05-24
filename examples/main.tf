terraform {
  required_providers {
    hcp = {
      source  = "hashicorp/hcp"
      version = "~> 0"
    }
    vsphere = {
      source  = "hashicorp/vsphere"
      version = "~> 2.5"
    }
    vault = {
      source = "hashicorp/vault"
      version = "~> 4.0"
    }
  }
  
  cloud {
    organization = "aaron-vm-demo"
    workspaces {
      project = "VMware Demo"
      name = "my-first-vsphere-vm"
    }
  }
}

provider "vault" {
  skip_child_token = true
}

/*data "vault_ldap_dynamic_credentials" "this" {
  mount     = "ldap"
  role_name = "vsphere_access"
}

provider "vsphere" {
  password = data.vault_ldap_dynamic_credentials.this.password
  user = "${data.vault_ldap_dynamic_credentials.this.username}@hashicorp.local"
  vsphere_server = "vcsa-98975.fe9dbbb3.asia-southeast1.gve.goog"
}*/

data "vault_ldap_static_credentials" "this" {
  mount     = "ldap"
  role_name = "sr_vault_01"
}

provider "vsphere" {
  password = data.vault_ldap_static_credentials.this.password
  user = "${data.vault_ldap_static_credentials.this.username}@hashicorp.local"
  vsphere_server = "vcsa-98975.fe9dbbb3.asia-southeast1.gve.goog"
}


output "ldap_username" {
  value = "${data.vault_ldap_static_credentials.this.username}@hashicorp.local"
}

/*output "ldap_distinguished_name" {
  value = data.vault_ldap_static_credentials.this.distinguished_names
}*/

output "ldap_password" {
  value = nonsensitive(data.vault_ldap_static_credentials.this.password)
}

/*
data "hcp_packer_artifact" "this" {
  bucket_name  = "base-ubuntu-2204"
  channel_name = "latest"
  platform     = "vsphere"
  region       = "Datacenter"
}*/

module "vm" {
  source = "github.com/tfo-apj-demos/terraform-vsphere-virtual-machine?ref=v1.2.0"

  hostname          = "demo-vm-cloudbrokerAz"
  datacenter        = "Datacenter"
  cluster           = "cluster"
  primary_datastore = "vsanDatastore"
  folder_path       = "Demo Workloads"
  networks = {
    "seg-general" : "dhcp"
  }
  #template = data.hcp_packer_artifact.this.external_identifier
  template = "base-ubuntu-2204-20240519100918"
  tags = {
    "application" = "tfc-agent"
  }
}