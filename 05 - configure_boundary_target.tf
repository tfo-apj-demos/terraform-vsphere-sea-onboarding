# module "ssh_role" {
#   source = "github.com/tfo-apj-demos/terraform-vault-ssh-role?ref=1.0.0"

#   ssh_role_name = "${var.github_username}-gcve-terraform-cloud-agent"
# }

# module "tfc_agent_target" {
#   source               = "github.com/tfo-apj-demos/terraform-boundary-target-refactored"

#   project_name         = var.github_username
#   target_name          = "gcve-tfc-agent"
#   hosts                = ["${module.tfc-agent.virtual_machine_name}.hashicorp.local"]
#   port                 = 22
#   target_type          = "ssh"

#   # Vault credential configurations
#   use_credentials      = true
#   credential_store_token = module.ssh_role.token
#   vault_address        = var.vault_address
#   credential_source    = "vault"
#   credential_path      = module.ssh_role.credential_path

#   # Optional alias
#   alias_name           = "${module.tfc-agent.virtual_machine_name}.hashicorp.local"
# }