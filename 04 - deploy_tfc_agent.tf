data "hcp_packer_artifact" "this" {
  bucket_name  = "base-ubuntu-2204"
  channel_name = "latest"
  platform     = "vsphere"
  region       = "Datacenter"
}

resource "tfe_agent_pool" "this" {
  name = "gcve_agent_pool"
}

resource "tfe_agent_token" "this" {
  agent_pool_id = tfe_agent_pool.this.id
  description   = "agent token for vsphere environment"
}

module "tfc-agent" {
  source  = "github.com/tfo-apj-demos/terraform-vsphere-virtual-machine?ref=v1.2.0"

  hostname          = "tfc-agent-${count.index}"
  datacenter        = var.datacenter
  cluster           = var.cluster
  primary_datastore = var.primary_datastore
  folder_path       = var.folder_path
  networks          = var.networks
  template          = data.hcp_packer_artifact.this.external_identifier

  userdata = templatefile("${path.module}/templates/userdata.yaml.tmpl", {
    agent_token = tfe_agent_token.this.token
    agent_name  = "tfc-agent-${count.index}"
  })

  tags = var.tags

  count = var.instance_count
}
