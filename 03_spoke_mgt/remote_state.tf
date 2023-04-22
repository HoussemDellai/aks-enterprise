data "terraform_remote_state" "hub" {
  count   = var.enable_vnet_peering || var.enable_firewall ? 1 : 0
  backend = "local" # "remote"

  config = {
    path = "../02_hub/terraform.tfstate"
  }
}
