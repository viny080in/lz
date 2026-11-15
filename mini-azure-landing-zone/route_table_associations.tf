
# Development subnet associations

resource "azurerm_subnet_route_table_association" "dev_workload" {
  subnet_id      = azurerm_subnet.workload.id
  route_table_id = azurerm_route_table.dev.id
}

resource "azurerm_subnet_route_table_association" "dev_management" {
  subnet_id      = azurerm_subnet.management.id
  route_table_id = azurerm_route_table.dev.id
}

# Production subnet associations

resource "azurerm_subnet_route_table_association" "prod_application" {
  subnet_id      = azurerm_subnet.prod_application.id
  route_table_id = azurerm_route_table.prod.id
}

resource "azurerm_subnet_route_table_association" "prod_data" {
  subnet_id      = azurerm_subnet.prod_data.id
  route_table_id = azurerm_route_table.prod.id
}
