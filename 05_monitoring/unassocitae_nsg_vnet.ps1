# deassociate all NSGs from all Subnets from a VNET
ForEach($subnet in $(az network vnet subnet list --vnet-name vnet-spoke-aks -g rg-esp-spoke-aks-infra --query [*].name -o tsv))
{
    echo "Deassociating NSG from Subnet $subnet ..."
    az network vnet subnet update --vnet-name vnet-spoke-aks -g rg-esp-spoke-aks-infra --name $subnet --network-security-group null --no-wait
}