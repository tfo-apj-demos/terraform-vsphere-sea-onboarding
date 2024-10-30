# Usage: This file is used to read the ldap role credentials from Vault for vSphere and NSX providers.

# Local Definitions for common settings
locals {
  vault_mount_ldap    = "ldap"
  vault_mount_secrets = "secrets"
  secret_path_prefix  = "hcp_sp/${var.github_username}"
}

# Usage: Fetch LDAP static credentials for vSphere provider role
data "vault_ldap_static_credentials" "vm_builder" {
  mount     = local.vault_mount_ldap
  role_name = "vm_builder"
}

# Usage: Retrieve specific secrets from Vault's KV secrets engine v2
data "vault_kv_secret_v2" "this" {
  mount = local.vault_mount_secrets
  name  = local.secret_path_prefix
}