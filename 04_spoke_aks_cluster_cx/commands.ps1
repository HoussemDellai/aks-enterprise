$env:ARM_SUBSCRIPTION_ID=(az account show --query id -o tsv)   # if using Windows

terraform init

terraform plan -out tfplan

terraform apply tfplan