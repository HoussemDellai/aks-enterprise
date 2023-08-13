
# Creates a private key in PEM format
resource "tls_private_key" "private_key" {
  algorithm = "RSA" # RSA, ECDSA, ED25519
}

# Open issue: TLS provider doesn't support yet PKCS12 format
# https://github.com/hashicorp/terraform-provider-tls/issues/205
# resource "tls_self_signed_cert" "tls_cert" {
#   private_key_pem = tls_private_key.private_key.private_key_pem # file("private_key.pem")

#   subject {
#     common_name  = "aca-app.apps.houssem15.com"
#     organization = "Houssem, Inc"
#   }

#   validity_period_hours = 48

#   allowed_uses = [
#     "key_encipherment",
#     "digital_signature",
#     "server_auth",
#   ]
# }
