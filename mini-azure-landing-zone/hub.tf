
resource "azurerm_virtual_network" "hub" {
  name                = "vnet-lz-hub"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  address_space = ["10.10.0.0/16"]

  tags = {
    environment  = "shared"
    project      = "mini-landing-zone"
    managed_by   = "opentofu"
    framework    = "CAF"
    owner        = "platform-team"
    network_role = "hub"
  }
}
