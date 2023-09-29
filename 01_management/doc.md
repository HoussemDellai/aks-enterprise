<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.2.8 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | = 3.69.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm.subscription_hub"></a> [azurerm.subscription\_hub](#provider\_azurerm.subscription\_hub) | 3.69.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_log_analytics_solution.solution](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/log_analytics_solution) | resource |
| [azurerm_log_analytics_workspace.workspace](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/log_analytics_workspace) | resource |
| [azurerm_resource_group.rg_management](https://registry.terraform.io/providers/hashicorp/azurerm/3.69.0/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_log_analytics_workspace"></a> [log\_analytics\_workspace](#input\_log\_analytics\_workspace) | Name of the Log Analytics Workspace. | `any` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | A prefix used for all resources | `string` | n/a | yes |
| <a name="input_resources_location"></a> [resources\_location](#input\_resources\_location) | Location of the resource group. | `any` | n/a | yes |
| <a name="input_subscription_id_hub"></a> [subscription\_id\_hub](#input\_subscription\_id\_hub) | Subscription ID for Hub | `any` | n/a | yes |
| <a name="input_subscription_id_spoke"></a> [subscription\_id\_spoke](#input\_subscription\_id\_spoke) | Subscription ID for Spoke | `any` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | <pre>{<br>  "architecture": "Hub&Spoke",<br>  "environment": "development",<br>  "source": "terraform"<br>}</pre> | no |
| <a name="input_tenant_id_hub"></a> [tenant\_id\_hub](#input\_tenant\_id\_hub) | Azure AD tenant ID for Hub | `any` | n/a | yes |
| <a name="input_tenant_id_spoke"></a> [tenant\_id\_spoke](#input\_tenant\_id\_spoke) | Azure AD tenant ID for Spoke | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_log_analytics_workspace"></a> [log\_analytics\_workspace](#output\_log\_analytics\_workspace) | n/a |
<!-- END_TF_DOCS -->