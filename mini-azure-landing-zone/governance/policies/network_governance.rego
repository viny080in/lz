
package networkgovernance

# ==========================================
# Approved VNet Address Spaces
# ==========================================

expected_vnets := {
    "vnet-lz-dev": "10.0.0.0/16",
    "vnet-lz-hub": "10.10.0.0/16",
    "vnet-lz-prod": "10.20.0.0/16",
}

deny contains msg if {
    some rc in input.resource_changes
    rc.type == "azurerm_virtual_network"

    after := rc.change.after
    after != null

    not after.name in object.keys(expected_vnets)

    msg := sprintf(
        "Unapproved virtual network name: %s",
        [after.name]
    )
}

deny contains msg if {
    some rc in input.resource_changes
    rc.type == "azurerm_virtual_network"

    after := rc.change.after
    after != null

    expected_cidr := expected_vnets[after.name]

    after.address_space != [expected_cidr]

    msg := sprintf(
        "Invalid address space for VNet %s. Expected %s",
        [after.name, expected_cidr]
    )
}

# ==========================================
# Required Hub-and-Spoke Architecture
# ==========================================

resource_named(resource_type, resource_name) if {
    some rc in input.resource_changes
    rc.type == resource_type
    rc.change.after.name == resource_name
}

deny contains "Missing Hub virtual network" if {
    not resource_named(
        "azurerm_virtual_network",
        "vnet-lz-hub"
    )
}

deny contains "Missing Development virtual network" if {
    not resource_named(
        "azurerm_virtual_network",
        "vnet-lz-dev"
    )
}

deny contains "Missing Production virtual network" if {
    not resource_named(
        "azurerm_virtual_network",
        "vnet-lz-prod"
    )
}

# ==========================================
# Required Bidirectional VNet Peering
# ==========================================

required_peerings := {
    "peer-hub-to-dev",
    "peer-dev-to-hub",
    "peer-hub-to-prod",
    "peer-prod-to-hub",
}

deny contains msg if {
    some peering in required_peerings

    not resource_named(
        "azurerm_virtual_network_peering",
        peering
    )

    msg := sprintf(
        "Missing required VNet peering: %s",
        [peering]
    )
}

# ==========================================
# Required Network Security Associations
# ==========================================

deny contains "Insufficient subnet NSG associations" if {
    count([
        rc |
        some rc in input.resource_changes
        rc.type == "azurerm_subnet_network_security_group_association"
        rc.change.after != null
    ]) < 5
}

# ==========================================
# Required Route Table Associations
# ==========================================

deny contains "Insufficient subnet route table associations" if {
    count([
        rc |
        some rc in input.resource_changes
        rc.type == "azurerm_subnet_route_table_association"
        rc.change.after != null
    ]) < 4
}

# ==========================================
# Required Central Firewall
# ==========================================

deny contains "Missing Azure Firewall" if {
    not resource_named(
        "azurerm_firewall",
        "afw-lz-hub"
    )
}

deny contains "Missing Azure Firewall Policy" if {
    not resource_named(
        "azurerm_firewall_policy",
        "afwp-lz-hub"
    )
}

deny contains "Missing Firewall Policy Rule Collection Group" if {
    not resource_named(
        "azurerm_firewall_policy_rule_collection_group",
        "rcg-lz-hub-baseline"
    )
}
