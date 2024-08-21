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
resource "tfe_variable_set" "identity" {
  for_each = {
    "gcve_workspace_identity" = "gcve_workspace_identity_tfc",
    "provider_config"         = "provider_config"
  }

  name = each.value
}

resource "tfe_variable" "gcve_workspace_identity" {
  for_each = toset(local.gcve_workspace_identity_tfc_vars)

  key             = each.value
  value           = each.value == "TFC_VAULT_RUN_ROLE" ? vault_jwt_auth_backend_role.this.role_name : data.hcp_vault_secrets_secret.this[each.value].secret_value
  category        = "env"
  variable_set_id = tfe_variable_set.identity["gcve_workspace_identity"].id
  sensitive       = each.value == "TFC_VAULT_ENCODED_CACERT"
}

// Consolidated provider configuration variables
resource "tfe_variable" "provider_config" {
  for_each = {
    "BOUNDARY_TOKEN"    = var.BOUNDARY_TOKEN,
    "BOUNDARY_ADDRESS"  = var.boundary_address,
    "VSPHERE_SERVER"    = var.vsphere_server,
    "NSXT_MANAGER_HOST" = var.nsxt_manager_host
    "VAULT_ADDR"        = var.vault_address,
  }

  key             = each.key
  value           = each.value
  category        = "env"
  variable_set_id = tfe_variable_set.identity["provider_config"].id
  sensitive       = each.key == "BOUNDARY_TOKEN" // Consider if other keys need to be sensitive
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
  name         = var.tfc_project_name
  organization = var.tfc_organization_name
}

resource "tfe_project_variable_set" "this" {
  for_each = {
    "gcve_workspace_identity" = tfe_variable_set.identity["gcve_workspace_identity"].id,
    "provider_config"         = tfe_variable_set.identity["provider_config"].id
  }

  variable_set_id = each.value
  project_id      = tfe_project.this.id
}

// Configure Workspace
resource "tfe_workspace" "this" {
  organization = var.tfc_organization_name
  project_id   = tfe_project.this.id
  name         = "hello-vmware"
}

resource "tfe_workspace_settings" "this" {
  workspace_id   = tfe_workspace.this.id
  execution_mode = "agent"
  agent_pool_id  = tfe_agent_pool_allowed_workspaces.this.agent_pool_id
}
