# install Azure CLI in Ubuntu
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# instal Terraform CLI in Ubuntu
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# register Azure preview features
az feature register --name EnableOIDCIssuerPreview --namespace Microsoft.ContainerService
az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableOIDCIssuerPreview')].{Name:name,State:properties.state}"
# wait until feature is registered (about 10 minutes)
# while (1) {az feature list -o table --query "[?contains(name, 'Microsoft.ContainerService/EnableOIDCIssuerPreview')].{Name:name,State:properties.state}"; sleep 5}

az provider register --namespace Microsoft.ContainerService

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
az aks get-credentials --name aks-cluster --resource-group $(terraform output -raw resource_group_name) --overwrite-existing

kubelogin convert-kubeconfig -l azurecli

kubectl get nodes

kubectl get all -n velero

# deploy sample apps with PVCs
kubectl apply -f applications_samples

# create some data files (to test backups and restores):
kubectl exec -it nginx-csi-disk-zrs -n csi-disk-zrs -- touch /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginx-csi-disk-lrs -n csi-disk-lrs -- touch /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginx-csi-file-zrs -n csi-file-zrs -- touch /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginx-file-lrs -n file-lrs -- touch /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginxstatefulset-0 -n diskstatefulset -- touch /mnt/azuredisk/some-data-file.txt

# check that data is created:
kubectl exec -it nginx-csi-disk-zrs -n csi-disk-zrs -- ls /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginx-csi-disk-lrs -n csi-disk-lrs -- ls /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginx-csi-file-zrs -n csi-file-zrs -- ls /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginx-file-lrs -n file-lrs -- ls /mnt/azuredisk/some-data-file.txt
kubectl exec -it nginxstatefulset-0 -n diskstatefulset -- ls /mnt/azuredisk/some-data-file.txt

# Create a backup for primary AKS cluster: (https://velero.io/docs/v1.8/resource-filtering/)
velero backup create manual-backup1 -w

# Describe created backup:
velero backup describe manual-backup1 --details



# creating VNET Peering across different tenants and subscriptions
# AKS is private and peering is not yet set
terraform plan -out tfplan -target="azurerm_virtual_network_peering.peering_vnet_aks_vnet_vm_jumpbox" -target="azurerm_virtual_network_peering.peering_vnet_vm_jumpbox_vnet_aks" -target="azurerm_private_dns_zone_virtual_network_link.link_private_dns_aks_vnet_vm_devbox"

# push git changes
git add . | git commit -m "configured aks aad app" | git push

# cleanup resources using terraform
terraform destroy

# cleanup resources using Azure CLI
# delete AKS admin group
$groups = (az ad group list --query "[?displayName=='group_aks_admins']" | ConvertFrom-Json)
ForEach($group in $groups)
{
    echo "Deleting $($group.displayName) ..."
    az ad group delete --group $group.id
}

# delete SPNs

# delete resources groups
ForEach($rg_name in $(az group list --query [*].name -o tsv))
{
    echo "Deleting $rg_name ..."
    az group delete -n $rg_name --yes --no-wait
}


az network bastion ssh --name "bastion_host" --resource-group "rg-spoke-mgt" --target-resource-id "/subscriptions/59d574d4-1c03-4092-ab22-312ed594eec9/resourceGroups/rg-spoke-mgt/providers/Microsoft.Compute/virtualMachines/vm-jumpbox-linux" --auth-type "password" --username "houssem"


az login
az account set -s Microsoft-Azure-2
az acr login -n acrforakstf0111
docker pull acrforakstf0111.azurecr.io/hello-world:latest