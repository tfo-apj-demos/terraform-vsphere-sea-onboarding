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
  template = "base-ubuntu-2204-20240728100948"
  tags = {
    "application" = "tfc-agent"
  }
}