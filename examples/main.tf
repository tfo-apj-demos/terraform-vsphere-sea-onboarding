data "vault_ldap_static_credentials" "vm_builder" {
  mount     = "ldap"
  role_name = "vm_builder"
}

provider "vsphere" {
  user           = "${data.vault_ldap_static_credentials.vm_builder.username}@hashicorp.local"
  password       = data.vault_ldap_static_credentials.vm_builder.password
  vsphere_server = "vcsa-98975.fe9dbbb3.asia-southeast1.gve.goog"
}

output "ldap_username" {
  value = "${data.vault_ldap_static_credentials.vm_builder.username}@hashicorp.local"
}

data "vault_kv_secret_v2" "this" {
  mount = "secrets"
  name  = "hcp_sp/${var.github_username}"
}

data "hcp_packer_artifact" "this" {
  bucket_name  = "docker-ubuntu-2204"
  channel_name = "latest"
  platform     = "vsphere"
  region       = "Datacenter"
}

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
  
  template = data.hcp_packer_artifact.this.external_identifier
  tags = {
    "application" = "tfc-agent"
  }
}