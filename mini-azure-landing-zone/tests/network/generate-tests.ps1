
# ==========================================
# Network Governance Test Generator
# ==========================================

$resources = [System.Collections.Generic.List[object]]::new()

function New-PlanResource {
    param(
        [string]$Type,
        [string]$Name,
        [object]$After
    )

    return @{
        type = $Type
        name = $Name
        change = @{
            actions = @("create")
            before = $null
            after = $After
        }
    }
}

# Virtual Networks

$resources.Add((New-PlanResource "azurerm_virtual_network" "hub" @{
    name = "vnet-lz-hub"
    address_space = @("10.10.0.0/16")
}))

$resources.Add((New-PlanResource "azurerm_virtual_network" "lz" @{
    name = "vnet-lz-dev"
    address_space = @("10.0.0.0/16")
}))

$resources.Add((New-PlanResource "azurerm_virtual_network" "prod" @{
    name = "vnet-lz-prod"
    address_space = @("10.20.0.0/16")
}))

# Bidirectional VNet Peering

$peerings = @(
    "peer-hub-to-dev",
    "peer-dev-to-hub",
    "peer-hub-to-prod",
    "peer-prod-to-hub"
)

foreach ($name in $peerings) {
    $resources.Add((New-PlanResource `
        "azurerm_virtual_network_peering" `
        $name `
        @{ name = $name }))
}

# Five NSG Associations

$nsgAssociations = @(
    "dev_workload",
    "dev_management",
    "prod_application",
    "prod_data",
    "hub_shared_services"
)

foreach ($name in $nsgAssociations) {
    $resources.Add((New-PlanResource `
        "azurerm_subnet_network_security_group_association" `
        $name `
        @{ name = $name }))
}

# Four Route Table Associations

$routeAssociations = @(
    "dev_workload",
    "dev_management",
    "prod_application",
    "prod_data"
)

foreach ($name in $routeAssociations) {
    $resources.Add((New-PlanResource `
        "azurerm_subnet_route_table_association" `
        $name `
        @{ name = $name }))
}

# Azure Firewall

$resources.Add((New-PlanResource "azurerm_firewall" "hub" @{
    name = "afw-lz-hub"
}))

# Firewall Policy

$resources.Add((New-PlanResource "azurerm_firewall_policy" "hub" @{
    name = "afwp-lz-hub"
}))

# Firewall Policy Rule Collection Group

$resources.Add((New-PlanResource "azurerm_firewall_policy_rule_collection_group" "hub" @{
    name = "rcg-lz-hub-baseline"
}))

# ==========================================
# Save Compliant Fixture
# ==========================================

$validPlan = @{
    resource_changes = @($resources.ToArray())
}

$validPlan |
    ConvertTo-Json -Depth 20 |
    Set-Content tests/network/valid-network-plan.json

# ==========================================
# Generate Non-Compliant Fixture
# ==========================================

$invalidResources = @(
    $validPlan.resource_changes |
    Where-Object {
        $_.name -ne "peer-hub-to-prod" -and
        $_.name -ne "hub_shared_services"
    }
)

# Introduce an unapproved CIDR

$invalidVnet = $invalidResources |
    Where-Object {
        $_.type -eq "azurerm_virtual_network" -and
        $_.change.after.name -eq "vnet-lz-dev"
    }

$invalidVnet.change.after.address_space = @("10.99.0.0/16")

# Remove Azure Firewall to test mandatory security controls

$invalidResources = @(
    $invalidResources |
    Where-Object {
        $_.type -ne "azurerm_firewall"
    }
)

$invalidPlan = @{
    resource_changes = $invalidResources
}

$invalidPlan |
    ConvertTo-Json -Depth 20 |
    Set-Content tests/network/invalid-network-plan.json

Write-Host "Network governance fixtures generated."
