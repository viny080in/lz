
# Development associations

resource "azurerm_subnet_network_security_group_association" "dev_workload" {
  subnet_id = azurerm_subnet.workload.id

  network_security_group_id = azurerm_network_security_group.dev_workload.id
}

resource "azurerm_subnet_network_security_group_association" "dev_management" {
  subnet_id = azurerm_subnet.management.id

  network_security_group_id = azurerm_network_security_group.dev_management.id
}

# Production associations

resource "azurerm_subnet_network_security_group_association" "prod_application" {
  subnet_id = azurerm_subnet.prod_application.id

  network_security_group_id = azurerm_network_security_group.prod_application.id
}

resource "azurerm_subnet_network_security_group_association" "prod_data" {
  subnet_id = azurerm_subnet.prod_data.id

  network_security_group_id = azurerm_network_security_group.prod_data.id
}

# Hub shared services association

resource "azurerm_subnet_network_security_group_association" "hub_shared_services" {
  subnet_id = azurerm_subnet.hub_shared_services.id

  network_security_group_id = azurerm_network_security_group.hub_shared_services.id
}
