resource "azurerm_subnet" "workload" {
  name                 = "snet-workload"
  resource_group_name  = azurerm_resource_group.lz.name
  virtual_network_name = azurerm_virtual_network.lz.name

  address_prefixes = ["10.0.1.0/24"]
}

resource "azurerm_subnet" "management" {
  name                 = "snet-management"
  resource_group_name  = azurerm_resource_group.lz.name
  virtual_network_name = azurerm_virtual_network.lz.name

  address_prefixes = ["10.0.2.0/24"]
}