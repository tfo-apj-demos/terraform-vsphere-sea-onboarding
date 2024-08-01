# Usage: This file is used to read the ldap role credentials from Vault for vSphere and NSX providers.

data "vault_ldap_static_credentials" "vm_builder" {
  mount     = "ldap"
  role_name = "vm_builder"
}

data "vault_ldap_static_credentials" "nsx_read_only" {
  mount     = "ldap"
  role_name = "nsx_read_only"
}

data "vault_kv_secret_v2" "this" {
  mount = "secrets"
  name  = "hcp_sp/${var.github_username}"
}