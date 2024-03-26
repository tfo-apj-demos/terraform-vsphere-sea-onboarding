locals {
  gcve_workspace_identity_tfc_vars = [
    "TFC_VAULT_ADDR",
    "TFC_VAULT_AUTH_PATH",
    "TFC_VAULT_PROVIDER_AUTH",
    "TFC_VAULT_RUN_ROLE",
    "TFC_VAULT_WORKLOAD_IDENTITY_AUDIENCE",
    "TFC_VAULT_ENCODED_CACERT"
  ]
}

data "hcp_vault_secrets_secret" "this" {
  for_each    = toset(local.gcve_workspace_identity_tfc_vars)
  app_name    = "gcve-tfc-workspace-identity"
  secret_name = each.value
}

resource "tfe_variable_set" "this" {
  name = "gcve_workspace_identity_tfc"
}

resource "tfe_variable" "this" {
  for_each = toset(local.gcve_workspace_identity_tfc_vars)

  key             = each.value
  value           = each.value == "TFC_VAULT_RUN_ROLE" ? vault_jwt_auth_backend_role.this.role_name : data.hcp_vault_secrets_secret.this[each.value].secret_value
  category        = "env"
  variable_set_id = tfe_variable_set.this.id
  sensitive       = true
}
