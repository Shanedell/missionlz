# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

###############################
## STAGE 2: Networking      ###
###############################

module "hub-network" {
  providers  = { azurerm = azurerm.hub }
  depends_on = [azurerm_resource_group.hub]
  source     = "../modules/hub"

  location                 = var.location
  resource_group_name      = azurerm_resource_group.hub.name
  vnet_name                = var.hub_vnetname
  vnet_address_space       = var.hub_vnet_address_space
  client_address_space     = var.hub_client_address_space
  management_address_space = var.hub_management_address_space

  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
  tags                                = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

module "firewall" {
  providers  = { azurerm = azurerm.hub }
  depends_on = [azurerm_resource_group.hub, module.hub-network]
  source     = "../modules/firewall"

  sub_id               = var.hub_subid
  resource_group_name  = module.hub-network.resource_group_name
  location             = var.location
  vnet_name            = module.hub-network.virtual_network_name
  vnet_address_space   = module.hub-network.virtual_network_address_space
  client_address_space = var.hub_client_address_space

  firewall_name                   = var.firewall_name
  firewall_sku_name               = var.firewall_sku_name
  firewall_sku                    = contains(local.firewall_premium_environments, lower(var.environment)) ? "Premium" : "Standard"
  firewall_client_subnet_name     = module.hub-network.firewall_client_subnet_name
  firewall_management_subnet_name = module.hub-network.firewall_management_subnet_name
  firewall_policy_name            = var.firewall_policy_name

  client_ipconfig_name = var.client_ipconfig_name
  client_publicip_name = var.client_publicip_name

  management_ipconfig_name = var.management_ipconfig_name
  management_publicip_name = var.management_publicip_name

  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
  tags                                = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

module "spoke-network-t0" {
  providers  = { azurerm = azurerm.tier0 }
  depends_on = [azurerm_resource_group.tier0, module.hub-network, module.firewall]
  source     = "../modules/spoke"

  location = azurerm_resource_group.tier0.location

  firewall_private_ip = module.firewall.firewall_private_ip

  laws_location     = var.location
  laws_workspace_id = azurerm_log_analytics_workspace.laws.workspace_id
  laws_resource_id  = azurerm_log_analytics_workspace.laws.id

  spoke_rgname             = azurerm_resource_group.tier0.name
  spoke_vnetname           = var.tier0_vnetname
  spoke_vnet_address_space = var.tier0_vnet_address_space
  subnets                  = var.tier0_subnets
  tags                     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_virtual_network_peering" "t0-to-hub" {
  provider   = azurerm.tier0
  depends_on = [azurerm_resource_group.tier0, module.spoke-network-t0, module.hub-network, module.firewall]

  name                         = "${var.tier0_vnetname}-to-${var.hub_vnetname}"
  resource_group_name          = azurerm_resource_group.tier0.name
  virtual_network_name         = var.tier0_vnetname
  remote_virtual_network_id    = module.hub-network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub-to-t0" {
  provider   = azurerm.hub
  depends_on = [azurerm_resource_group.hub, module.spoke-network-t0, module.hub-network, module.firewall]

  name                         = "${var.hub_vnetname}-to-${var.tier0_vnetname}"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = var.hub_vnetname
  remote_virtual_network_id    = module.spoke-network-t0.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

module "spoke-network-t1" {
  providers  = { azurerm = azurerm.tier1 }
  depends_on = [azurerm_resource_group.tier1, module.hub-network, module.firewall]
  source     = "../modules/spoke"

  location = azurerm_resource_group.tier1.location

  firewall_private_ip = module.firewall.firewall_private_ip

  laws_location     = var.location
  laws_workspace_id = azurerm_log_analytics_workspace.laws.workspace_id
  laws_resource_id  = azurerm_log_analytics_workspace.laws.id

  spoke_rgname             = azurerm_resource_group.tier1.name
  spoke_vnetname           = var.tier1_vnetname
  spoke_vnet_address_space = var.tier1_vnet_address_space
  subnets                  = var.tier1_subnets
  tags                     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_virtual_network_peering" "t1-to-hub" {
  provider   = azurerm.tier1
  depends_on = [azurerm_resource_group.tier1, module.spoke-network-t1, module.hub-network, module.firewall]

  name                         = "${var.tier1_vnetname}-to-${var.hub_vnetname}"
  resource_group_name          = azurerm_resource_group.tier1.name
  virtual_network_name         = var.tier1_vnetname
  remote_virtual_network_id    = module.hub-network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub-to-t1" {
  provider   = azurerm.hub
  depends_on = [azurerm_resource_group.hub, module.spoke-network-t1, module.hub-network, module.firewall]

  name                         = "${var.hub_vnetname}-to-${var.tier1_vnetname}"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = var.hub_vnetname
  remote_virtual_network_id    = module.spoke-network-t1.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

module "spoke-network-t2" {
  providers  = { azurerm = azurerm.tier2 }
  depends_on = [azurerm_resource_group.tier2, module.hub-network, module.firewall]
  source     = "../modules/spoke"

  location = azurerm_resource_group.tier2.location

  firewall_private_ip = module.firewall.firewall_private_ip

  laws_location     = var.location
  laws_workspace_id = azurerm_log_analytics_workspace.laws.workspace_id
  laws_resource_id  = azurerm_log_analytics_workspace.laws.id

  spoke_rgname             = azurerm_resource_group.tier2.name
  spoke_vnetname           = var.tier2_vnetname
  spoke_vnet_address_space = var.tier2_vnet_address_space
  subnets                  = var.tier2_subnets
  tags                     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_virtual_network_peering" "t2-to-hub" {
  provider   = azurerm.tier2
  depends_on = [azurerm_resource_group.tier2, module.spoke-network-t2, module.hub-network, module.firewall]

  name                         = "${var.tier2_vnetname}-to-${var.hub_vnetname}"
  resource_group_name          = azurerm_resource_group.tier2.name
  virtual_network_name         = var.tier2_vnetname
  remote_virtual_network_id    = module.hub-network.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}

resource "azurerm_virtual_network_peering" "hub-to-t2" {
  provider   = azurerm.hub
  depends_on = [azurerm_resource_group.hub, module.spoke-network-t2, module.hub-network, module.firewall]

  name                         = "${var.hub_vnetname}-to-${var.tier2_vnetname}"
  resource_group_name          = azurerm_resource_group.hub.name
  virtual_network_name         = var.hub_vnetname
  remote_virtual_network_id    = module.spoke-network-t2.virtual_network_id
  allow_virtual_network_access = true
  allow_forwarded_traffic      = true
}
