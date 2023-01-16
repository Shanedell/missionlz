# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### STAGE 3: Remote Access   ###
################################

#########################################################################
### This stage is optional based on the value of `create_bastion_jumpbox`
#########################################################################

module "jumpbox-subnet" {
  count = var.create_bastion_jumpbox ? 1 : 0

  providers  = { azurerm = azurerm.hub }
  depends_on = [azurerm_resource_group.hub, module.hub-network, module.firewall, azurerm_log_analytics_workspace.laws]
  source     = "../modules/subnet"

  name                 = var.jumpbox_subnet.name
  location             = var.location
  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = var.hub_vnetname
  address_prefixes     = var.jumpbox_subnet.address_prefixes
  service_endpoints    = lookup(var.jumpbox_subnet, "service_endpoints", [])

  private_endpoint_network_policies_enabled     = lookup(var.jumpbox_subnet, "private_endpoint_network_policies_enabled", null)
  private_link_service_network_policies_enabled = lookup(var.jumpbox_subnet, "private_link_service_network_policies_enabled", null)

  nsg_name  = var.jumpbox_subnet.nsg_name
  nsg_rules = var.jumpbox_subnet.nsg_rules

  routetable_name     = var.jumpbox_subnet.routetable_name
  firewall_ip_address = module.firewall.firewall_private_ip

  log_analytics_storage_id            = module.hub-network.log_analytics_storage_id
  log_analytics_workspace_id          = azurerm_log_analytics_workspace.laws.workspace_id
  log_analytics_workspace_location    = var.location
  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
  tags                                = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

module "bastion-host" {
  count = var.create_bastion_jumpbox ? 1 : 0

  providers  = { azurerm = azurerm.hub }
  depends_on = [azurerm_resource_group.hub, module.hub-network, module.firewall, module.jumpbox-subnet]
  source     = "../modules/bastion"

  resource_group_name   = azurerm_resource_group.hub.name
  location              = azurerm_resource_group.hub.location
  virtual_network_name  = var.hub_vnetname
  bastion_host_name     = var.bastion_host_name
  subnet_address_prefix = var.bastion_address_space
  public_ip_name        = var.bastion_public_ip_name
  ipconfig_name         = var.bastion_ipconfig_name
  tags                  = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

module "jumpbox" {
  count = var.create_bastion_jumpbox ? 1 : 0

  providers  = { azurerm = azurerm.hub }
  depends_on = [azurerm_resource_group.hub, module.hub-network, module.firewall, module.jumpbox-subnet]
  source     = "../modules/jumpbox"

  resource_group_name  = azurerm_resource_group.hub.name
  virtual_network_name = var.hub_vnetname
  subnet_name          = var.jumpbox_subnet.name
  location             = var.location

  keyvault_name = var.jumpbox_keyvault_name

  tenant_id = data.azurerm_client_config.current_client.tenant_id
  object_id = data.azurerm_client_config.current_client.object_id

  windows_name          = var.jumpbox_windows_vm_name
  windows_size          = var.jumpbox_windows_vm_size
  windows_publisher     = var.jumpbox_windows_vm_publisher
  windows_offer         = var.jumpbox_windows_vm_offer
  windows_sku           = var.jumpbox_windows_vm_sku
  windows_image_version = var.jumpbox_windows_vm_version

  linux_name          = var.jumpbox_linux_vm_name
  linux_size          = var.jumpbox_linux_vm_size
  linux_publisher     = var.jumpbox_linux_vm_publisher
  linux_offer         = var.jumpbox_linux_vm_offer
  linux_sku           = var.jumpbox_linux_vm_sku
  linux_image_version = var.jumpbox_linux_vm_version
  tags                = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}
