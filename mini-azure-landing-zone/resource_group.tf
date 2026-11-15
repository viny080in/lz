resource "azurerm_resource_group" "lz" {
  name     = "rg-lz-dev"
  location = "uksouth"

  tags = {
    environment = "dev"
    project     = "mini-landing-zone"
    managed_by  = "opentofu"
    framework   = "CAF"
    owner       = "platform-team"
  }
}