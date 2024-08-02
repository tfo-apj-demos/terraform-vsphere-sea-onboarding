data "vault_ldap_static_credentials" "vm_builder" {
  mount     = "ldap"
  role_name = "vm_builder"
}

provider "vsphere" {
  user           = "${data.vault_ldap_static_credentials.vm_builder.username}@hashicorp.local"
  password       = data.vault_ldap_static_credentials.vm_builder.password
  vsphere_server = "vcsa-98975.fe9dbbb3.asia-southeast1.gve.goog"
}

module "vm" {
  source = "github.com/tfo-apj-demos/terraform-vsphere-virtual-machine?ref=1.0.0"

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

module "ssh_role" {
  source = "github.com/tfo-apj-demos/terraform-vault-ssh-role?ref=1.0.0"

  # insert required variables here
  ssh_role_name = "${var.TFC_WORKSPACE_ID}-vm-access"
}

# --- Create Boundary targets for the TFC Agent
module "boundary_target" {
  source = "github.com/tfo-apj-demos/terraform-boundary-target?ref=1.0.0"

  hosts = [
    {
      "hostname" = module.vm.virtual_machine_name
      "address"  = module.vm.ip_address
    }
  ]

  services = [
    {
      name = "ssh",
      type = "ssh",
      port = "22",
      credential_paths = [module.ssh_role.credential_path]
    }
  ]

  project_name    = "CloudbrokerAz" 
  host_catalog_id = "hcst_fGHoRryL4N"
  hostname_prefix = "ssh-CloudbrokerAz-vm"

  credential_store_token = module.ssh_role.token
  vault_address          = "https://vault.hashicorp.local:8200"
  #vault_ca_cert          = file("${path.root}/ca_cert_dir/ca_chain.pem")
}