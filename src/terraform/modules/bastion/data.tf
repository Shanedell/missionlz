# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

data "azurerm_resource_group" "bastion_host_rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "bastion_host_vnet" {
  name                = var.virtual_network_name
  resource_group_name = var.resource_group_name
}
