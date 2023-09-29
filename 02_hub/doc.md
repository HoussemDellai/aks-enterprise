<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.8 |
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | 1.8.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azapi.subscription_hub"></a> [azapi.subscription\_hub](#provider\_azapi.subscription\_hub) | 1.8.0 |
| <a name="provider_azurerm.subscription_hub"></a> [azurerm.subscription\_hub](#provider\_azurerm.subscription\_hub) | 3.69.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.1 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vm_jumpbox_linux"></a> [vm\_jumpbox\_linux](#module\_vm\_jumpbox\_linux) | ../modules/vm_linux | n/a |
| <a name="module_vm_jumpbox_windows"></a> [vm\_jumpbox\_windows](#module\_vm\_jumpbox\_windows) | ../modules/vm_windows | n/a |

## Resources

| Name | Type |
|------|------|
| [azapi_resource.appservice_domain](https://registry.terraform.io/providers/Azure/azapi/1.8.0/docs/resources/resource) | resource |
| [azurerm_bastion_host.bastion_host](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/bastion_host) | resource |
| [azurerm_dns_a_record.a_record_test](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_a_record.dns_a_record](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/dns_a_record) | resource |
| [azurerm_dns_ns_record.dns_ns_record](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/dns_ns_record) | resource |
| [azurerm_dns_zone.dns_zone_apps](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/dns_zone) | resource |
| [azurerm_dns_zone.dns_zone_parent](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/dns_zone) | resource |
| [azurerm_firewall.firewall](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/firewall) | resource |
| [azurerm_firewall_policy.firewall_policy](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/firewall_policy) | resource |
| [azurerm_firewall_policy_rule_collection_group.policy_group_deny](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/firewall_policy_rule_collection_group) | resource |
| [azurerm_public_ip.public_ip_bastion](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.public_ip_firewall](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/public_ip) | resource |
| [azurerm_public_ip.public_ip_firewall_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/public_ip) | resource |
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/resource_group) | resource |
| [azurerm_route.route_to_firewall](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/route) | resource |
| [azurerm_route_table.route_table_to_firewall](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/route_table) | resource |
| [azurerm_subnet.subnet_bastion](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet_firewall](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet_firewall_mgmt](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/subnet) | resource |
| [azurerm_subnet.subnet_vm](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/subnet) | resource |
| [azurerm_subnet_route_table_association.route_table_association](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/subnet_route_table_association) | resource |
| [azurerm_virtual_network.vnet_hub](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/virtual_network) | resource |
| [null_resource.firewall_monitor_workbook](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [azurerm_subscription.subscription_hub](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/data-sources/subscription) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_AgreedAt_DateTime"></a> [AgreedAt\_DateTime](#input\_AgreedAt\_DateTime) | n/a | `string` | n/a | yes |
| <a name="input_AgreedBy_IP_v6"></a> [AgreedBy\_IP\_v6](#input\_AgreedBy\_IP\_v6) | n/a | `string` | n/a | yes |
| <a name="input_cidr_subnet_bastion"></a> [cidr\_subnet\_bastion](#input\_cidr\_subnet\_bastion) | CIDR range for Subnet Bastion | `any` | n/a | yes |
| <a name="input_cidr_subnet_firewall"></a> [cidr\_subnet\_firewall](#input\_cidr\_subnet\_firewall) | CIDR for Firewall Subnet. | `any` | n/a | yes |
| <a name="input_cidr_subnet_firewall_mgmt"></a> [cidr\_subnet\_firewall\_mgmt](#input\_cidr\_subnet\_firewall\_mgmt) | CIDR for Firewall Management Subnet. | `any` | n/a | yes |
| <a name="input_cidr_subnet_vm"></a> [cidr\_subnet\_vm](#input\_cidr\_subnet\_vm) | CIDR for VM Subnet. | `any` | n/a | yes |
| <a name="input_cidr_vnet_hub"></a> [cidr\_vnet\_hub](#input\_cidr\_vnet\_hub) | HUB VNET address prefix | `any` | n/a | yes |
| <a name="input_contact"></a> [contact](#input\_contact) | Contact info for Domain Name Registration. | <pre>object({<br>    nameFirst = string<br>    nameLast  = string<br>    email     = string<br>    phone     = string<br>    addressMailing = object({<br>      address1   = string<br>      city       = string<br>      state      = string<br>      country    = string<br>      postalCode = string<br>    })<br>  })</pre> | n/a | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | n/a | yes |
| <a name="input_enable_bastion"></a> [enable\_bastion](#input\_enable\_bastion) | Creates a Bastion Host. | `bool` | n/a | yes |
| <a name="input_enable_firewall"></a> [enable\_firewall](#input\_enable\_firewall) | Creates an Azure Firewall. | `bool` | n/a | yes |
| <a name="input_enable_firewall_as_dns_server"></a> [enable\_firewall\_as\_dns\_server](#input\_enable\_firewall\_as\_dns\_server) | n/a | `bool` | n/a | yes |
| <a name="input_enable_vm_jumpbox_linux"></a> [enable\_vm\_jumpbox\_linux](#input\_enable\_vm\_jumpbox\_linux) | Creates a Linux VM Jumpbox. | `bool` | n/a | yes |
| <a name="input_enable_vm_jumpbox_windows"></a> [enable\_vm\_jumpbox\_windows](#input\_enable\_vm\_jumpbox\_windows) | Creates a Windows VM Jumpbox. | `bool` | n/a | yes |
| <a name="input_firewall_sku_tier"></a> [firewall\_sku\_tier](#input\_firewall\_sku\_tier) | n/a | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix used for all resources in this example | `string` | n/a | yes |
| <a name="input_resources_location"></a> [resources\_location](#input\_resources\_location) | Location of the resource group. | `any` | n/a | yes |
| <a name="input_subscription_id_hub"></a> [subscription\_id\_hub](#input\_subscription\_id\_hub) | Subscription ID for Hub | `any` | n/a | yes |
| <a name="input_subscription_id_spoke"></a> [subscription\_id\_spoke](#input\_subscription\_id\_spoke) | Subscription ID for Spoke | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "architecture": "Hub&Spoke",<br>  "environment": "development",<br>  "source": "terraform"<br>}</pre> | no |
| <a name="input_tenant_id_hub"></a> [tenant\_id\_hub](#input\_tenant\_id\_hub) | Azure AD tenant ID for Hub | `any` | n/a | yes |
| <a name="input_tenant_id_spoke"></a> [tenant\_id\_spoke](#input\_tenant\_id\_spoke) | Azure AD tenant ID for Spoke | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_dns_zone_apps"></a> [dns\_zone\_apps](#output\_dns\_zone\_apps) | n/a |
| <a name="output_firewall"></a> [firewall](#output\_firewall) | n/a |
| <a name="output_vnet_hub"></a> [vnet\_hub](#output\_vnet\_hub) | n/a |
<!-- END_TF_DOCS -->