
resource "azurerm_virtual_network" "prod" {
  name                = "vnet-lz-prod"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  address_space = ["10.20.0.0/16"]

  tags = {
    environment  = "prod"
    project      = "mini-landing-zone"
    managed_by   = "opentofu"
    framework    = "CAF"
    owner        = "platform-team"
    network_role = "spoke"
  }
}
