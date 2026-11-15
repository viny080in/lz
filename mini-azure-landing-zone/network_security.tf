
# ==========================================
# Development Workload NSG
# ==========================================

resource "azurerm_network_security_group" "dev_workload" {
  name                = "nsg-dev-workload"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  tags = {
    environment  = "dev"
    network_role = "workload"
    managed_by   = "opentofu"
  }
}

resource "azurerm_network_security_rule" "dev_workload_deny_prod" {
  name                       = "Deny-Production-Inbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "10.20.0.0/16"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.lz.name
  network_security_group_name = azurerm_network_security_group.dev_workload.name
}

# ==========================================
# Development Management NSG
# ==========================================

resource "azurerm_network_security_group" "dev_management" {
  name                = "nsg-dev-management"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  tags = {
    environment  = "dev"
    network_role = "management"
    managed_by   = "opentofu"
  }
}

resource "azurerm_network_security_rule" "dev_management_deny_prod" {
  name                       = "Deny-Production-Inbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "10.20.0.0/16"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.lz.name
  network_security_group_name = azurerm_network_security_group.dev_management.name
}

# ==========================================
# Production Application NSG
# ==========================================

resource "azurerm_network_security_group" "prod_application" {
  name                = "nsg-prod-application"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  tags = {
    environment  = "prod"
    network_role = "application"
    managed_by   = "opentofu"
  }
}

resource "azurerm_network_security_rule" "prod_application_deny_dev" {
  name                       = "Deny-Development-Inbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "10.0.0.0/16"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.lz.name
  network_security_group_name = azurerm_network_security_group.prod_application.name
}

# ==========================================
# Production Data NSG
# ==========================================

resource "azurerm_network_security_group" "prod_data" {
  name                = "nsg-prod-data"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  tags = {
    environment  = "prod"
    network_role = "data"
    managed_by   = "opentofu"
  }
}

resource "azurerm_network_security_rule" "prod_data_deny_dev" {
  name                       = "Deny-Development-Inbound"
  priority                   = 4000
  direction                  = "Inbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "10.0.0.0/16"
  destination_address_prefix = "*"

  resource_group_name         = azurerm_resource_group.lz.name
  network_security_group_name = azurerm_network_security_group.prod_data.name
}

# ==========================================
# Hub Shared Services NSG
# ==========================================

resource "azurerm_network_security_group" "hub_shared_services" {
  name                = "nsg-hub-shared-services"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  tags = {
    environment  = "shared"
    network_role = "shared-services"
    managed_by   = "opentofu"
  }
}
