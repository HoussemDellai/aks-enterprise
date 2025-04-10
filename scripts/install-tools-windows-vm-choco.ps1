# The script will be downloaded into the VM: C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.15\Downloads\0

# Install chocolately
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Azure CLI
# winget install -e --id Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements --silent --force
choco install azure-cli -y

# Install Kubernetes CLI
# winget install -e --id Kubernetes.kubectl --accept-package-agreements --accept-source-agreements --silent --force
choco install kubernetes-cli -y

# Install kubelogin
# winget install -e --id Microsoft.Azure.Kubelogin --accept-package-agreements --accept-source-agreements --silent --force
choco install azure-kubelogin -y

# Install Helm CLI
# winget install -e --id Helm.Helm --accept-package-agreements --accept-source-agreements --silent --force
choco install kubernetes-helm -y

# Install Headlamp
# winget install -e --id Headlamp.Headlamp --accept-package-agreements --accept-source-agreements

# Install Terraform
# winget install -e --id Hashicorp.Terraform --accept-package-agreements --accept-source-agreements
choco install terraform -y

# Install jq
# winget install -e --id stedolan.jq --accept-package-agreements --accept-source-agreements
# winget install -e --id MikeFarah.yq --accept-package-agreements --accept-source-agreements
choco install jq -y

# Install VS Code
# winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements
choco install vscode -y

# Install Edge
choco install microsoft-edge -y

# Install Git
# winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements
choco install git -y

# Install Azure Storage Explorer
# winget install -e --id Microsoft.Azure.StorageExplorer --accept-package-agreements --accept-source-agreements
choco install microsoftazurestorageexplorer -y

# Install curl
# winget install -e --id cURL.cURL --accept-package-agreements --accept-source-agreements
choco install curl -y

# Install python
# winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements
choco install python -y

Set-Alias -Name k -Value kubectl

# # (Optional) Install Docker for Desktop
choco install docker-desktop -y
choco install docker-cli -y

# Configure Auto-Complete
Set-ExecutionPolicy RemoteSigned
# Create profile when not exist
if (!(Test-Path -Path $PROFILE.CurrentUserAllHosts)) {
  New-Item -ItemType File -Path $PROFILE.CurrentUserAllHosts -Force
}
# Open the profile with an editor (e.g. good old Notepad)
# ii $PROFILE.CurrentUserAllHosts
# In the editor add the following lines to the profile:
$powershellProfile=@"
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# Autocompletion for arrow keys
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Import-Module posh-git

Import-Module PSReadLine
Set-PSReadLineOption -colors @{ Default = "Green"}
Set-PSReadLineOption -colors @{ Parameter = "Blue"}
Set-PSReadLineOption -colors @{ Command = "Magenta"}

function prompt {
" $ "
}

Import-Module Terminal-Icons

Clear

pwd

"@

$powershellProfile > $PSHOME\Profile.ps1 # $PROFILE.CurrentUserAllHosts

# # Set up language preference
# $LanguageList = Get-WinUserLanguageList
# $LanguageList.Add("fr-FR")
# Set-WinUserLanguageList $LanguageList

## Restart Terminal

# # Install Terraform extension in VS Code
# code --install-extension hashicorp.terraform

# cd .\Desktop\
# git clone https://github.com/HoussemDellai/aks-enterprise
# cd aks-enterprise
# code .

# az login --identity
# az account set --subscription "Microsoft-Azure-NonProd"
# az aks list -o table
# az aks get-credentials -g rg-lzaks-spoke-weu-aks-cluster -n aks-cluster

# kubelogin convert-kubeconfig -l azurecli

# kubectl get nodes
# kubectl get pods -A
# kubectl run nginx --image=nginx
# kubectl exec nginx -it -- ls
# kubectl create deployment nginx --image=nginx --replicas=3


# $ACR_NAME=$(az acr list --query [0].name -o tsv)
# $ACR_TOKEN=$(az acr login --name $ACR_NAME --expose-token --output tsv --query accessToken)
# docker login $ACR_NAME.azurecr.io -u $ACR_NAME -p $ACR_TOKEN

# docker pull $ACR_NAME.azurecr.io/hello-world:latest

# # IMDS
# Invoke-RestMethod -Headers @{"Metadata"="true"} -Method GET -NoProxy -Uri "http://169.254.169.254/metadata/instance?api-version=2021-02-01" | ConvertTo-Json -Depth 64