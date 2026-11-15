
resource "azurerm_subnet" "prod_application" {
  name                 = "snet-prod-application"
  resource_group_name  = azurerm_resource_group.lz.name
  virtual_network_name = azurerm_virtual_network.prod.name

  address_prefixes = ["10.20.1.0/24"]
}

resource "azurerm_subnet" "prod_data" {
  name                 = "snet-prod-data"
  resource_group_name  = azurerm_resource_group.lz.name
  virtual_network_name = azurerm_virtual_network.prod.name

  address_prefixes = ["10.20.2.0/24"]
}
