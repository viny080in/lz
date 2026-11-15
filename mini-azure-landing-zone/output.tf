output "resource_group_name" {
  value = azurerm_resource_group.lz.name
}

output "virtual_network_name" {
  value = azurerm_virtual_network.lz.name
}

output "subnet_names" {
  value = [
    azurerm_subnet.workload.name,
    azurerm_subnet.management.name
  ]
}