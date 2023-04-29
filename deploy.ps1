cd .\01_management
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init -upgrade
terraform plan -out tfplan
terraform apply tfplan

cd ..\02_hub
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init -upgrade
terraform plan -out tfplan
terraform apply tfplan

cd ..\03_spoke_aks_infra
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init -upgrade
terraform plan -out tfplan
terraform apply tfplan

cd ..\04_spoke_aks_cluster
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init -upgrade
terraform plan -out tfplan
terraform apply tfplan

cd ..\05_monitoring
rm terraform.tfstate
rm terraform.tfstate.backup

terraform init -upgrade
terraform plan -out tfplan
terraform apply tfplan