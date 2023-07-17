#!/bin/bash

# For other unhealthy statuses, review the Log Analytics agent for Linux VM extension logs files in 
# /var/log/azure/Microsoft.EnterpriseCloud.Monitoring.OmsAgentForLinux/*/extension.log 
# and 
# /var/log/azure/Microsoft.EnterpriseCloud.Monitoring.OmsAgentForLinux/*/CommandExecution.log.
# If the extension status is healthy but data isn't being uploaded, review the Log Analytics agent for Linux log files in 
# /var/opt/microsoft/omsagent/log/omsagent.log.

# Eliminate debconf: warnings
echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Update the system
sudo apt-get update -y

# Upgrade packages
sudo apt-get upgrade -y

# Install NGINX web server
sudo apt-get install -y nginx

# Change the default page of the NGINX web server
sudo echo "This is [$HOSTNAME] virtual machine" > /var/www/html/index.html

# Install curl and traceroute
sudo apt-get install -y curl traceroute

# install jq
apt install jq -y

# install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh

# install Azure CLI
# https://learn.microsoft.com/en-us/cli/azure/install-azure-cli-linux
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

az version

# install Terraform CLI
# https://learn.hashicorp.com/tutorials/terraform/install-cli
sudo apt-get update && sudo apt-get install -y gnupg software-properties-common

wget -O- https://apt.releases.hashicorp.com/gpg | \
    gpg --dearmor | \
    sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg

gpg --no-default-keyring \
    --keyring /usr/share/keyrings/hashicorp-archive-keyring.gpg \
    --fingerprint

echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] \
    https://apt.releases.hashicorp.com $(lsb_release -cs) main" | \
    sudo tee /etc/apt/sources.list.d/hashicorp.list

# install Terraform
sudo apt-get install -y terraform

terraform version

# install Kubernetes CLI
# https://kubernetes.io/docs/tasks/tools/install-kubectl-linux/
sudo apt-get update
sudo apt-get install -y ca-certificates curl

sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg

echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list

sudo apt-get update
sudo apt-get install -y kubectl

kubectl version

# install Helm
# https://helm.sh/docs/intro/install/
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

helm version

# install brew
# https://brew.sh/
apt install linuxbrew-wrapper -y
# sudo -i
# sudo apt-get install -y build-essential
# sudo apt install git -y
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
# echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/houssem/.profile
# echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/houssem/.profile
# eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
# brew install gcc

# install (Azure) kubelogin
# https://github.com/Azure/kubelogin
brew install Azure/kubelogin/kubelogin
brew update
brew upgrade Azure/kubelogin/kubelogin

# change command line colors
PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "



az login --identity
sudo -i

# login to ACR
ACR_NAME=$(az acr list --query [0].name -o tsv)
# enable admin mode for ACR
az acr update -n $ACR_NAME --admin-enabled true
# ACR_TOKEN=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
ACR_PASSWORD=$(az acr credential show -n $ACR_NAME --query 'passwords[0].value' -o tsv)
docker login $ACR_NAME.azurecr.io -u $ACR_NAME -p $ACR_PASSWORD

# az acr login -n $ACR_NAME

docker pull $ACR_NAME.azurecr.io/hello-world:latest

# IMDS
curl -s -H Metadata:true --noproxy "*" "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | jq

# check installs
az version
terraform version
kubectl version
helm version
kubelogin version

exit 0