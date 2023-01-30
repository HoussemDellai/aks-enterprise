data "terraform_remote_state" "level_1" {
  backend = "local" # "remote"

  config = {
    path = "../level_1/terraform.tfstate"
  }
}

data "azurerm_log_analytics_workspace" "workspace" {
  name                = var.log_analytics_workspace
  resource_group_name = var.rg_spoke_shared
}