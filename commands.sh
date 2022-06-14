# install Azure CLI in Ubuntu
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

# instal Terraform CLI in Ubuntu
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# register Azure preview fetures
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
az aks get-credentials --resource-group rg-aks-cluster --name aks-cluster

kubelogin convert-kubeconfig -l azurecli




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
velero backup create manual-backup1  -w

# Describe created backup:
velero backup describe manual-backup1 --details



# push git changes
git add . | git commit -m "configured aks aad app" | git push