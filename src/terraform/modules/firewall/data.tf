# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
data "azurerm_resource_group" "hub" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "hub" {
  name                = var.vnet_name
  resource_group_name = data.azurerm_resource_group.hub.name
}

data "azurerm_subnet" "fw_client_sn" {
  name                 = var.firewall_client_subnet_name
  virtual_network_name = data.azurerm_virtual_network.hub.name
  resource_group_name  = data.azurerm_resource_group.hub.name
}

data "azurerm_subnet" "fw_mgmt_sn" {
  name                 = var.firewall_management_subnet_name
  virtual_network_name = data.azurerm_virtual_network.hub.name
  resource_group_name  = data.azurerm_resource_group.hub.name
}
