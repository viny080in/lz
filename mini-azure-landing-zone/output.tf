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

output "hub_virtual_network_name" {
  value = azurerm_virtual_network.hub.name
}

output "hub_address_space" {
  value = azurerm_virtual_network.hub.address_space
}

output "hub_subnet_names" {
  value = [
    azurerm_subnet.hub_firewall.name,
    azurerm_subnet.hub_shared_services.name
  ]
}

output "prod_virtual_network_name" {
  value = azurerm_virtual_network.prod.name
}

output "prod_address_space" {
  value = azurerm_virtual_network.prod.address_space
}

output "prod_subnet_names" {
  value = [
    azurerm_subnet.prod_application.name,
    azurerm_subnet.prod_data.name
  ]
}

output "hub_dev_peering_names" {
  value = [
    azurerm_virtual_network_peering.hub_to_dev.name,
    azurerm_virtual_network_peering.dev_to_hub.name
  ]
}

output "hub_prod_peering_names" {
  value = [
    azurerm_virtual_network_peering.hub_to_prod.name,
    azurerm_virtual_network_peering.prod_to_hub.name
  ]
}

output "network_security_group_names" {
  value = [
    azurerm_network_security_group.dev_workload.name,
    azurerm_network_security_group.dev_management.name,
    azurerm_network_security_group.prod_application.name,
    azurerm_network_security_group.prod_data.name,
    azurerm_network_security_group.hub_shared_services.name
  ]
}

output "route_table_names" {
  value = [
    azurerm_route_table.dev.name,
    azurerm_route_table.prod.name
  ]
}

output "firewall_name" {
  value = azurerm_firewall.hub.name
}

output "firewall_private_ip" {
  value = azurerm_firewall.hub.ip_configuration[0].private_ip_address
}

output "firewall_public_ip" {
  value = azurerm_public_ip.firewall.ip_address
}

output "firewall_policy_name" {
  value = azurerm_firewall_policy.hub.name
}

