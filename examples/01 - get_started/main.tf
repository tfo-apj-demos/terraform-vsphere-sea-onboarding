module "onboarding" {
  source = "../../"

  boundary_address  = var.boundary_address
  BOUNDARY_TOKEN    = var.BOUNDARY_TOKEN
  vsphere_server    = var.vsphere_server
  nsxt_manager_host = var.nsxt_manager_host
  vault_address     = var.vault_address

  github_username       = var.github_username
  tfc_organization_name = var.tfc_organization_name
  enable_request_forwarding = false
}