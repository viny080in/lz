# Enterprise Governance Standards

## Naming conventions

Resource Group: rg-<workload>-<environment>
Virtual Network: vnet-<workload>-<environment>
Subnet: snet-<purpose>

## Approved environments

- dev
- test
- prod

## Mandatory tags

- environment
- project
- managed_by
- framework
- owner

## Approved Azure region

- uksouth

## Infrastructure management

All infrastructure must be managed using OpenTofu.