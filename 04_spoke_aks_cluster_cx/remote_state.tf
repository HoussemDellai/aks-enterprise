data "terraform_remote_state" "management" {
  backend = "local" # "remote"

  config = {
    path = "../01_management/terraform.tfstate"
  }
}

data "terraform_remote_state" "hub" {
  backend = "local" # "remote"

  config = {
    path = "../02_hub/terraform.tfstate"
  }
}

data "terraform_remote_state" "spoke_aks" {
  backend = "local" # "remote"

  config = {
    path = "../03_spoke_aks_infra/terraform.tfstate"
  }
}