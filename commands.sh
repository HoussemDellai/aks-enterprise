# install Azure CLI in Ubuntu
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# instal Terraform CLI in Ubuntu
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# install kubelogin CLI
sudo az aks install-cli
kubectl version --client
kubelogin --version

# login to Azure
az login

# start terraform deployment
terraform init

terraform fmt

terraform validate

terraform plan -out tfplan

# show only the changes
terraform show -json tfplan | jq '.' | jq -r '(.resource_changes[] | [.change.actions[], .type, .change.after.name]) | @tsv'

terraform apply tfplan

# connect to AKS cluster
az aks get-credentials --resource-group rg-aks-cluster --name aks-cluster

kubelogin convert-kubeconfig -l azurecli

# push git changes