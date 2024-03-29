ForEach($provider in [array]@("azurerm", "azuread", "http", "time", "azapi"))
{
    if ($provider -eq "azapi") 
    {
        $endpoint=$("https://api.github.com/repos/Azure/terraform-provider-$provider/releases/latest")
    } 
    else 
    {
        $endpoint=$("https://api.github.com/repos/hashicorp/terraform-provider-$provider/releases/latest")
    }

    $version=($(curl $endpoint).Content | ConvertFrom-Json).name
    
    echo "$provider $version"
}

function Get-Terraform-Providers-Version {

    # get latest version of azurerm provider

    ($(curl https://api.github.com/repos/hashicorp/terraform-provider-azurerm/releases/latest).Content | ConvertFrom-Json).name
    # v3.47.0

    # get latest version of azuread provider

    ($(curl https://api.github.com/repos/hashicorp/terraform-provider-azuread/releases/latest).Content | ConvertFrom-Json).name
    # v2.36.0

    # get latest version of azapi provider

    ($(curl https://api.github.com/repos/Azure/terraform-provider-azapi/releases/latest).Content | ConvertFrom-Json).name
    # v1.4.0

    # get latest version of http provider

    ($(curl https://api.github.com/repos/hashicorp/terraform-provider-http/releases/latest).Content | ConvertFrom-Json).name
    # v3.2.1

    # get latest version of time provider

    ($(curl https://api.github.com/repos/hashicorp/terraform-provider-time/releases/latest).Content | ConvertFrom-Json).name
    # v0.9.1
}