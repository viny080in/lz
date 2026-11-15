
# ==========================================
# Azure Firewall Public IP
# ==========================================

resource "azurerm_public_ip" "firewall" {
  name                = "pip-lz-firewall"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  allocation_method = "Static"
  sku               = "Standard"

  tags = {
    environment  = "shared"
    managed_by   = "opentofu"
    network_role = "firewall"
  }
}

# ==========================================
# Azure Firewall
# ==========================================

resource "azurerm_firewall" "hub" {
  name                = "afw-lz-hub"
  location            = azurerm_resource_group.lz.location
  resource_group_name = azurerm_resource_group.lz.name

  sku_name = "AZFW_VNet"
  sku_tier = "Standard"

  firewall_policy_id = azurerm_firewall_policy.hub.id

  ip_configuration {
    name                 = "hub-firewall-ipconfig"
    subnet_id            = azurerm_subnet.hub_firewall.id
    public_ip_address_id = azurerm_public_ip.firewall.id
  }

  tags = {
    environment  = "shared"
    project      = "mini-landing-zone"
    managed_by   = "opentofu"
    framework    = "CAF"
    owner        = "platform-team"
    network_role = "central-firewall"
  }
}
