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

sudo apt-get install terraform

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
sudo apt-get install build-essential
sudo apt install git -y
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo '# Set PATH, MANPATH, etc., for Homebrew.' >> /home/houssem/.profile
echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> /home/houssem/.profile
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

# install (Azure) kubelogin
# https://github.com/Azure/kubelogin
brew install Azure/kubelogin/kubelogin
brew update
brew upgrade Azure/kubelogin/kubelogin