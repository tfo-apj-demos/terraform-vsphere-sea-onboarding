data "vault_ldap_static_credentials" "vm_builder" {
  mount     = "ldap"
  role_name = "vm_builder"
}

module "vm" {
  source = "github.com/tfo-apj-demos/terraform-vsphere-virtual-machine?ref=1.0.0"

  hostname          = "demo-vm-${var.github_username}"
  datacenter        = "Datacenter"
  cluster           = "cluster"
  primary_datastore = "vsanDatastore"
  folder_path       = "Demo Workloads"
  networks = {
    "seg-general" : "dhcp"
  }

  #template = data.hcp_packer_artifact.this.external_identifier
  #template = "base-ubuntu-2204-20240818101106"
  template = "base-rhel-9-20240819054923"
  
  #insert any tags required for the VM
  tags = {
    "application" = var.github_username
  }
}

module "ssh_role" {
  source        = "github.com/tfo-apj-demos/terraform-vault-ssh-role?ref=1.0.0"
  ssh_role_name = "${var.TFC_WORKSPACE_ID}-vm-access"
}

# --- Create Boundary targets for the TFC Agent
module "boundary_target" {
  source = "github.com/tfo-apj-demos/terraform-boundary-target?ref=1.0.3"

  hosts = [
    {
      "hostname" = module.vm.virtual_machine_name
      "address"  = module.vm.ip_address
    }
  ]

  services = [
    {
      name             = "ssh",
      type             = "ssh",
      port             = "22",
      credential_paths = [module.ssh_role.credential_path]
    }
  ]

  project_name    = var.github_username
  hostname_prefix = "ssh-${var.github_username}-demo-vm"

  credential_store_token = module.ssh_role.token
  vault_address          = var.vault_address
}