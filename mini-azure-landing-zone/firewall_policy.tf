
# ==========================================
# Central Azure Firewall Policy
# ==========================================

resource "azurerm_firewall_policy" "hub" {
  name                = "afwp-lz-hub"
  resource_group_name = azurerm_resource_group.lz.name
  location            = azurerm_resource_group.lz.location

  sku = "Standard"

  tags = {
    environment = "shared"
    managed_by  = "opentofu"
    framework   = "CAF"
  }
}

# ==========================================
# Approved Shared Services Traffic
# ==========================================

resource "azurerm_firewall_policy_rule_collection_group" "hub" {
  name               = "rcg-lz-hub-baseline"
  firewall_policy_id = azurerm_firewall_policy.hub.id
  priority           = 100

  network_rule_collection {
    name     = "allow-approved-shared-services"
    priority = 100
    action   = "Allow"

    rule {
      name                  = "dev-to-shared-services-https"
      protocols             = ["TCP"]
      source_addresses      = ["10.0.1.0/24"]
      destination_addresses = ["10.10.1.0/24"]
      destination_ports     = ["443"]
    }

    rule {
      name                  = "prod-to-shared-services-https"
      protocols             = ["TCP"]
      source_addresses      = ["10.20.1.0/24"]
      destination_addresses = ["10.10.1.0/24"]
      destination_ports     = ["443"]
    }
  }
}
