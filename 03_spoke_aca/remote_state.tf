data terraform_remote_state hub {
  backend = "local" # "remote"

  config = {
    path = "../01_hub/terraform.tfstate"
  }
}