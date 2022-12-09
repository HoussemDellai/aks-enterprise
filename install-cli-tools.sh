#!/bin/bash

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

sudo apt update

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

# install jq
apt install jq -y

az login --identity
sudo -i
PS1="\[\e]0;\u@\h: \w\a\]${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ "
az acr login -n acrforakstf011

# check installs
az version
terraform version
kubectl version
helm version
kubelogin version

exit 0