# The script will be downloaded into the VM: C:\Packages\Plugins\Microsoft.Compute.CustomScriptExtension\1.10.15\Downloads\0

# Install chocolately
# Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Azure CLI
winget install -e --id Microsoft.AzureCLI --accept-package-agreements --accept-source-agreements --silent --force

# Install Kubernetes tools

winget install -e --id Kubernetes.kubectl --accept-package-agreements --accept-source-agreements --silent --force

winget install -e --id Microsoft.Azure.Kubelogin --accept-package-agreements --accept-source-agreements --silent --force

winget install -e --id Helm.Helm --accept-package-agreements --accept-source-agreements --silent --force

winget install -e --id Headlamp.Headlamp --accept-package-agreements --accept-source-agreements

winget install -e --id argoproj.argocd --accept-package-agreements --accept-source-agreements

winget install -e --id Hashicorp.Terraform --accept-package-agreements --accept-source-agreements

winget install -e --id stedolan.jq --accept-package-agreements --accept-source-agreements

winget install -e --id MikeFarah.yq --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.VisualStudioCode --accept-package-agreements --accept-source-agreements

winget install -e --id Git.Git --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Azure.StorageExplorer --accept-package-agreements --accept-source-agreements

winget install -e --id cURL.cURL --accept-package-agreements --accept-source-agreements

winget install -e --id Python.Python.3.13 --accept-package-agreements --accept-source-agreements

winget install -e --id Python.Python.3.12 --accept-package-agreements --accept-source-agreements

winget install Microsoft.DotNet.SDK.9 --accept-package-agreements --accept-source-agreements

winget install Microsoft.DotNet.SDK.8 --accept-package-agreements --accept-source-agreements

winget install Microsoft.DotNet.DesktopRuntime.9 --accept-package-agreements --accept-source-agreements

winget install Microsoft.DotNet.AspNetCore.9 --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.DotNet.SDK.Preview --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Azd --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Bicep --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Azure.AztfExport --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Azure.FunctionsCoreTools --accept-package-agreements --accept-source-agreements

winget install -e --id Brave.Brave --accept-package-agreements --accept-source-agreements

winget install -e --id Brave.Brave.Dev --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Sqlcmd --accept-package-agreements --accept-source-agreements 

winget install -e --id=Microsoft.AzureDataStudio --accept-package-agreements --accept-source-agreements

winget install -e --id Anaconda.Miniconda3 --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.RemoteDesktopClient --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.PowerToys --accept-package-agreements --accept-source-agreements

winget install -e --id Microsoft.Sysinternals.BGInfo --accept-package-agreements --accept-source-agreements

winget install -e --id=astral-sh.uv --accept-package-agreements --accept-source-agreements

winget install -e --id Logitech.GHUB --accept-package-agreements --accept-source-agreements

winget install -e --id Docker.DockerDesktop --accept-package-agreements --accept-source-agreements

winget install -e --id Meltytech.Shotcut --accept-package-agreements --accept-source-agreements

# winget install -e --id Microsoft.VisualStudio.2022.Professional --accept-package-agreements --accept-source-agreements

dotnet tool install --global azure-cost-cli

pip install auto-editor

Set-Alias -Name k -Value kubectl

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

# save commands history
Copy-Item -Path .\ConsoleHost_history.txt -Destination (Get-PSReadlineOption).HistorySavePath -Force

# clone github repo
git clone https://github.com/HoussemDellai/ai-course


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