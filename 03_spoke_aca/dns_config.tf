# az network dns record-set cname set-record `
#    --record-set-name $SUBDOMAIN_NAME `
#    --resource-group $RG `
#    --zone-name $DOMAIN_NAME `
#    --cname $FQDN
resource "azurerm_dns_cname_record" "cname_record" {
  name                = "aca-app"
  zone_name           = data.terraform_remote_state.hub.0.outputs.dns_zone_apps.name
  resource_group_name = data.terraform_remote_state.hub.0.outputs.dns_zone_apps.resource_group_name
  ttl                 = 300
  record              = azurerm_container_app.aca_frontend.latest_revision_fqdn # todo: this should be ingress.fqdn
}

# az network dns record-set txt add-record `
#    --resource-group $RG `
#    --zone-name $DOMAIN_NAME `
#    --record-set-name "asuid.$SUBDOMAIN_NAME" `
#    --value $DOMAIN_VERIFICATION_CODE
resource "azurerm_dns_txt_record" "txt_record" {
  name                = "asuid.aca-app"
  zone_name           = data.terraform_remote_state.hub.0.outputs.dns_zone_apps.name
  resource_group_name = data.terraform_remote_state.hub.0.outputs.dns_zone_apps.resource_group_name
  ttl                 = 300

  record {
    value = azurerm_container_app.aca_frontend.custom_domain_verification_id
  }
}
