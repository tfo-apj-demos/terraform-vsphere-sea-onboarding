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

// Configure TFC Organisation
resource "tfe_variable_set" "this" {
  name = "gcve_workspace_identity_tfc"
}

resource "tfe_variable" "this" {
  for_each = toset(local.gcve_workspace_identity_tfc_vars)

  key             = each.value
  value           = each.value == "TFC_VAULT_RUN_ROLE" ? vault_jwt_auth_backend_role.this.role_name : data.hcp_vault_secrets_secret.this[each.value].secret_value
  category        = "env"
  variable_set_id = tfe_variable_set.this.id
  sensitive       = false
}

resource "tfe_agent_pool" "this" {
  name = "gcve_agent_pool"
}

resource "tfe_agent_pool_allowed_workspaces" "this" {
  agent_pool_id         = tfe_agent_pool.this.id
  allowed_workspace_ids = [tfe_workspace.this.id]
}

resource "tfe_agent_token" "this" {
  agent_pool_id = tfe_agent_pool.this.id
  description   = "agent token for vsphere environment"
}

// Configure Project
resource "tfe_project" "this" {
  name         = "VMware Demo"
  organization = var.tfc_organization_name
}

resource "tfe_project_variable_set" "this" {
  variable_set_id = tfe_variable_set.this.id
  project_id      = tfe_project.this.id
}

// Configure Workspace
resource "tfe_workspace" "this" {
  organization = var.tfc_organization_name
  project_id   = tfe_project.this.id
  name         = "my-first-vsphere-vm" 
}

resource "tfe_workspace_settings" "this" {
  workspace_id   = tfe_workspace.this.id
  execution_mode = "agent"
  agent_pool_id  = tfe_agent_pool_allowed_workspaces.this.agent_pool_id
}