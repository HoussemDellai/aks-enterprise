data "terraform_remote_state" "hub" {
  count   = var.enable_hub_spoke ? 1 : 0
  backend = "local" # "remote"

  config = {
    path = "../01_hub/terraform.tfstate"
  }
}