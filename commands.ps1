copy providers.tf level_1
copy variables.tf level_1
copy terraform.tfvars level_1

terraform -chdir=level_1 init
terraform -chdir=level_1 plan -out tfplan
terraform -chdir=level_1 apply tfplan




copy providers.tf level_2
copy variables.tf level_2
copy terraform.tfvars level_2

terraform -chdir=level_2 init

terraform plan -out tfplan -chdir=level_2