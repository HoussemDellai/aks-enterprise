resource azuread_application app_kasten {
  display_name = "spn_kasten"
}

resource azuread_service_principal spn_kasten {
  application_id = azuread_application.app_kasten.application_id
}

resource azuread_service_principal_password password_spn_kasten {
  service_principal_id = azuread_service_principal.spn_kasten.id
}

resource azurerm_role_assignment spn_kasten_role {
  scope                = data.azurerm_subscription.current.id
  role_definition_name = "Contributor"
  principal_id         = azuread_service_principal.spn_kasten.object_id
}