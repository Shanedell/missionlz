# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "hub-network" {
  source                              = "../virtual-network"
  location                            = var.location
  resource_group_name                 = var.resource_group_name
  vnet_name                           = var.vnet_name
  vnet_address_space                  = var.vnet_address_space
  log_analytics_workspace_resource_id = var.log_analytics_workspace_resource_id
  tags                                = var.tags
}
