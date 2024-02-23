data "tfe_organization" "this" {
  name = var.tfc_organization_name
}
resource "vault_jwt_auth_backend_role" "this" {
  backend         = "jwt"
  role_name       = "tfc"
  token_policies  = [
    "terraform_cloud",
    "generate_certificate",
    "create_child_token",
    "ldap_reader"
  ]

  bound_audiences = ["vault.tfc.workspace.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub = "organization:${var.tfc_organization_name}:*"
    terraform_organization_id = data.tfe_organization.this.id
  }
  user_claim      = "terraform_full_workspace"
  role_type       = "jwt"

  claim_mappings = {
    terraform_project_id = "terraform_project_id"
    terraform_workspace_id = "terraform_workspace_id"
  }
}