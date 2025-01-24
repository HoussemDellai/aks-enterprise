# AKS module

## Important notes

### When is a DCE required?
AMA will use a public endpoint by default to retrieve its configuration from Azure Monitor. A DCE is only required if you're using private link.
Legacy data collection scenarios such as collecting resource logs with diagnostic settings or Application insights data collection do not yet use DCEs in any way.
Src: https://docs.azure.cn/en-us/azure-monitor/essentials/data-collection-endpoint-overview?tabs=portal#when-is-a-dce-required

### Limitations of DCE
Data collection endpoints only support Log Analytics workspaces and Azure Monitor Workspace as destinations for collected data.