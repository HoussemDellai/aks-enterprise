resource "null_resource" "enable_oidci_issuer" {
  provisioner "local-exec" {
    command = <<-EOT
      az feature register --name EnableOIDCIssuerPreview --namespace Microsoft.ContainerService
    EOT
  }
}