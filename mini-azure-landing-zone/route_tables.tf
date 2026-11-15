
# ==========================================
# Development Spoke Route Table
# ==========================================

resource "azurerm_route_table" "dev" {
  name                = "rt-dev-spoke"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  # Route internet-bound traffic through the Hub Firewall.
  route {
    name                   = "default-to-hub-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }

  # Route Production traffic through the Hub Firewall.
  route {
    name                   = "prod-via-hub-firewall"
    address_prefix         = "10.20.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }

  tags = {
    environment  = "dev"
    managed_by   = "opentofu"
    network_role = "spoke-routing"
  }
}

# ==========================================
# Production Spoke Route Table
# ==========================================

resource "azurerm_route_table" "prod" {
  name                = "rt-prod-spoke"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  # Route internet-bound traffic through the Hub Firewall.
  route {
    name                   = "default-to-hub-firewall"
    address_prefix         = "0.0.0.0/0"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }

  # Route Development traffic through the Hub Firewall.
  route {
    name                   = "dev-via-hub-firewall"
    address_prefix         = "10.0.0.0/16"
    next_hop_type          = "VirtualAppliance"
    next_hop_in_ip_address = azurerm_firewall.hub.ip_configuration[0].private_ip_address
  }

  tags = {
    environment  = "prod"
    managed_by   = "opentofu"
    network_role = "spoke-routing"
  }
}
