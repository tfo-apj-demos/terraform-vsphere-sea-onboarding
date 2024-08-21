module "ssh_role" {
  source = "github.com/tfo-apj-demos/terraform-vault-ssh-role?ref=1.0.0"

  # insert required variables here
  ssh_role_name = "${var.github_username}-tfc-agent-access"
}

# --- Create Boundary targets for the TFC Agent
module "boundary_target" {
  source = "github.com/tfo-apj-demos/terraform-boundary-target?ref=1.0.4"

  hosts = [
    {
      "hostname" = module.tfc-agent.virtual_machine_name
      "address"  = module.tfc-agent.ip_address
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
  hostname_prefix = "${var.github_username}-tfcagent"

  credential_store_token = module.ssh_role.token
  vault_address          = var.vault_address
  #vault_ca_cert          = file("${path.root}/ca_cert_dir/ca_chain.pem")
}