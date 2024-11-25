data "tfe_organization" "this" {
  name = var.tfc_organization_name
}
resource "vault_jwt_auth_backend_role" "this" {
  backend   = "jwt"
  role_name = "${var.github_username}"
  token_policies = [
    "terraform_cloud",
    "generate_certificate",
    "create_child_token",
    "ldap_reader",
    "create_ssh_role",
    "create_workspace_policy"
  ]

  bound_audiences   = ["vault.tfc.workspace.identity"]
  bound_claims_type = "glob"
  bound_claims = {
    sub                       = "organization:${var.tfc_organization_name}:project:${var.tfc_project_name}:*"
    terraform_organization_id = data.tfe_organization.this.id
  }
  user_claim = "terraform_workspace_id"
  role_type  = "jwt"

  claim_mappings = {
    terraform_project_id   = "terraform_project_id"
    terraform_workspace_id = "terraform_workspace_id"
  }
}
