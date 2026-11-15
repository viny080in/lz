package landingzone

# Resource Group naming convention
deny contains msg if {
    some rc in input.resource_changes
    rc.type == "azurerm_resource_group"

    after := rc.change.after
    after != null

    not regex.match(
        "^rg-[a-z0-9]+-[a-z0-9]+$",
        after.name
    )

    msg := sprintf(
        "Invalid Resource Group name: %s",
        [after.name]
    )
}

# Virtual Network naming convention
deny contains msg if {
    some rc in input.resource_changes
    rc.type == "azurerm_virtual_network"

    after := rc.change.after
    after != null

    not regex.match(
        "^vnet-[a-z0-9]+-[a-z0-9]+$",
        after.name
    )

    msg := sprintf(
        "Invalid VNet name: %s",
        [after.name]
    )
}

# Subnet naming convention
deny contains msg if {
    some rc in input.resource_changes
    rc.type == "azurerm_subnet"

    after := rc.change.after
    after != null

    not regex.match(
        "^snet-[a-z0-9-]+$",
        after.name
    )

    msg := sprintf(
        "Invalid subnet name: %s",
        [after.name]
    )
}

# Mandatory tags
required_tags := {
    "environment",
    "project",
    "managed_by",
    "framework",
    "owner"
}

deny contains msg if {
    some rc in input.resource_changes
    rc.type in {
        "azurerm_resource_group",
        "azurerm_virtual_network"
    }

    after := rc.change.after
    after != null

    some tag in required_tags

    object.get(after.tags, tag, "") == ""

    msg := sprintf(
        "Resource %s is missing mandatory tag: %s",
        [after.name, tag]
    )
}

# Environment validation
deny contains msg if {
    some rc in input.resource_changes
    rc.type in {
        "azurerm_resource_group",
        "azurerm_virtual_network"
    }

    after := rc.change.after
    after != null

    environment := object.get(after.tags, "environment", "")

    not environment in {"dev", "test", "prod"}

    msg := sprintf(
        "Invalid environment tag on resource: %s",
        [after.name]
    )
}

# Approved Azure region
deny contains msg if {
    some rc in input.resource_changes

    rc.type in {
        "azurerm_resource_group",
        "azurerm_virtual_network"
    }

    after := rc.change.after
    after != null

    after.location != "uksouth"

    msg := sprintf(
        "Unapproved Azure region: %s",
        [after.location]
    )
}