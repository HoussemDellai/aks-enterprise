data "terraform_remote_state" "hub" {
  count   = var.enable_hub_spoke ? 1 : 0
  backend = "local" # "remote"

  config = {
    path = "../01_hub/terraform.tfstate"
  }
}

data "terraform_remote_state" "management" {
  count   = var.enable_monitoring ? 1 : 0
  backend = "local" # "remote"

  config = {
    path = "../01_management/terraform.tfstate"
  }
}

data "terraform_remote_state" "spoke_aks" {
  backend = "local" # "remote"

  config = {
    path = "../03_spoke_aks/terraform.tfstate"
  }
}