
# Reserved subnet for Azure Firewall.
# Firewall deployment is intentionally excluded from this milestone.

resource "azurerm_subnet" "hub_firewall" {
  name                 = "AzureFirewallSubnet"
  resource_group_name  = azurerm_resource_group.lz.name
  virtual_network_name = azurerm_virtual_network.hub.name

  address_prefixes = ["10.10.0.0/26"]
}

# Shared services subnet.

resource "azurerm_subnet" "hub_shared_services" {
  name                 = "snet-hub-shared-services"
  resource_group_name  = azurerm_resource_group.lz.name
  virtual_network_name = azurerm_virtual_network.hub.name

  address_prefixes = ["10.10.1.0/24"]
}
