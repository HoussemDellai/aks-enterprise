## Deploy an AKS cluster with an Application Gateway (Brownfield)
This sample terraform template deploys an AKS cluster with an Application Gateway.  
1) Deploy an Application Gateway  
2) Deploy an AKS cluster with 2 node pools  
3) Enable AKS Addon to deploy AGIC and attach Application Gateway  
4) Add Contributor role assignment for the AGIC Managed Identity (the AGIC addon missed this step although it works with Azure CLI)  

It deploys AGIC using only the addon which won't use AAD Pod Identity.
It works with both Kubenet and Azure CNI.

This sample was taken and changed from:
https://docs.microsoft.com/en-us/azure/developer/terraform/create-k8s-cluster-with-aks-applicationgateway-ingress

Deploy the resources:
```bash
# login to Azure
az login
# deploy AKS & Application Gateway with Terraform
terraform init
terraform validate
terraform plan -out prod.tfplan
terraform apply prod.tfplan -auto-approve
# connect to AKS cluster
az aks get-credentials --name aks-cluster --resource-group rg-aks-cluster
# deploy sample app into AKS
kubectl apply -f aspnetapp.yaml
# view ingress resource
kubectl get ingress
```

## Enable AGIC addon to deploy new Application Gateway
Here is an example:  
https://peterdaugaardrasmussen.com/2021/12/04/terraform-how-to-set-up-azure-application-gateway-ingress-controller/  
Another example:  
https://thomasthornton.cloud/2021/10/25/creating-azure-kubernetes-service-with-application-gateway-ingress-using-terraform-and-deploying-a-sample-app/