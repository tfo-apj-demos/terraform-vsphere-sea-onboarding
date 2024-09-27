module "ssh_role" {
  source = "github.com/tfo-apj-demos/terraform-vault-ssh-role?ref=1.0.0"

  ssh_role_name = "${var.github_username}-gcve-terraform-cloud-agent"
}

# --- Create Boundary targets for the TFC Agent
module "boundary_target" {
  source = "github.com/tfo-apj-demos/terraform-boundary-target?ref=2.0.3"

  project_name           = var.github_username
  hostname_prefix        = "gcve-tfc-agent"
  credential_store_token = module.ssh_role.token
  vault_address          = var.vault_address

  # Provide the fqdn and ensure the fqdn is unique and used for mapping
  hosts = [{
    fqdn = "${module.tfc-agent.virtual_machine_name}.hashicorp.local"
  }]

  services = [
    {
      type               = "ssh"
      port               = 22
      use_existing_creds = false
      use_vault_creds    = true
      credential_path    = module.ssh_role.credential_path
    }
  ]
}