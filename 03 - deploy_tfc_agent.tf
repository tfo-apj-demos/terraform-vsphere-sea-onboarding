data "hcp_packer_artifact" "this" {
  bucket_name  = "docker-ubuntu-2204"
  channel_name = "latest"
  platform     = "vsphere"
  region       = "Datacenter"
}

# data "nsxt_policy_ip_pool" "this" {
#   display_name = "10 - gcve-foundations"
# }

# resource "nsxt_policy_ip_address_allocation" "this" {
#   display_name = "tfc-agent-${var.github_username}"
#   pool_path    = data.nsxt_policy_ip_pool.this.path
# }

module "tfc-agent" {
  source = "github.com/tfo-apj-demos/terraform-vsphere-virtual-machine?ref=1.0.0"

  hostname          = "tfc-agent-${var.github_username}"
  datacenter        = var.datacenter
  cluster           = var.cluster
  primary_datastore = var.primary_datastore
  folder_path       = var.folder_path
  template          = data.hcp_packer_artifact.this.external_identifier
  networks = {
    "seg-general" = "dhcp"
  }
  dns_server_list = var.dns_server_list
  gateway         = var.gateway
  dns_suffix_list = var.dns_suffix_list


  userdata = templatefile("${path.module}/templates/userdata.yaml.tmpl", {
    agent_token = tfe_agent_token.this.token
    agent_name  = "tfc-agent-${var.github_username}"
    enable_request_forwarding = var.enable_request_forwarding
  })

  tags = var.tags
}