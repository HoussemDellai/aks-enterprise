resource "acme_registration" "reg" {
  account_key_pem = tls_private_key.private_key.private_key_pem
  email_address   = "houssem.dellai@live.com"
}

resource "acme_certificate" "certificate" {
  account_key_pem           = acme_registration.reg.account_key_pem
  common_name               = "aca-app.apps.houssem15.com"
  subject_alternative_names = ["aca-app.apps.houssem15.com"]
  certificate_p12_password  = "@Aa123456789"

  dns_challenge {
    provider = "azuredns"
    config = {
      AZURE_SUBSCRIPTION_ID = "82f6d75e-85f4-434a-ab74-5dddd9fa8910"
      AZURE_RESOURCE_GROUP  = "rg-lzaks-hub-weu"
    }
  }
}

output "certificate_p12" {
  value     = acme_certificate.certificate.certificate_p12
  sensitive = true
}
