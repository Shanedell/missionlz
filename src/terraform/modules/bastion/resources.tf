# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

resource "azurerm_subnet" "bastion_host_subnet" {
  name                 = "AzureBastionSubnet" # the name of the subnet must be 'AzureBastionSubnet'
  resource_group_name  = var.resource_group_name
  virtual_network_name = data.azurerm_virtual_network.bastion_host_vnet.name
  address_prefixes     = [cidrsubnet(var.subnet_address_prefix, 0, 0)]
}

resource "azurerm_public_ip" "bastion_host_pip" {
  name                = var.public_ip_name
  location            = var.location
  resource_group_name = var.resource_group_name
  allocation_method   = "Static"
  sku                 = "Standard"
  tags                = var.tags
}

resource "azurerm_bastion_host" "bastion_host" {
  name                = var.bastion_host_name
  location            = var.location
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                 = var.ipconfig_name
    subnet_id            = azurerm_subnet.bastion_host_subnet.id
    public_ip_address_id = azurerm_public_ip.bastion_host_pip.id
  }

  tags = var.tags
}
