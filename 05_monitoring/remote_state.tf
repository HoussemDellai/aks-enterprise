data "terraform_remote_state" "management" {
  # count   = var.enable_monitoring ? 1 : 0
  backend = "local" # "remote"

  config = {
    path = "../01_management/terraform.tfstate"
  }
}