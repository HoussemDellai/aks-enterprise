data "terraform_remote_state" "hub" {
  count   = 1
  backend = "local" # "remote"

  config = {
    path = "../02_hub/terraform.tfstate"
  }
}
