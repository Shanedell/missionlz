# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

module "windows-virtual-machine" {
  source               = "../windows-virtual-machine"
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.subnet_name
  name                 = var.windows_name
  size                 = var.windows_size
  admin_username       = var.admin_username
  admin_password       = random_password.windows-jumpbox-password.result
  publisher            = var.windows_publisher
  offer                = var.windows_offer
  sku                  = var.windows_sku
  image_version        = var.windows_image_version
  tags                 = var.tags
}

module "linux-virtual-machine" {
  source               = "../linux-virtual-machine"
  resource_group_name  = var.resource_group_name
  location             = var.location
  virtual_network_name = var.virtual_network_name
  subnet_name          = var.subnet_name
  name                 = var.linux_name
  size                 = var.linux_size
  admin_username       = var.admin_username
  admin_password       = random_password.linux-jumpbox-password.result
  publisher            = var.linux_publisher
  offer                = var.linux_offer
  sku                  = var.linux_sku
  image_version        = var.linux_image_version
  tags                 = var.tags
}
