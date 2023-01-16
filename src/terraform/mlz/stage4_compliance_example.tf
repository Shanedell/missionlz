# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

#####################################
### STAGE 4: Compliance example   ###
#####################################

module "hub-policy-assignment" {
  count = var.create_policy_assignment ? 1 : 0

  providers                           = { azurerm = azurerm.hub }
  source                              = "../modules/policy-assignments"
  depends_on                          = [azurerm_resource_group.hub, azurerm_log_analytics_workspace.laws]
  resource_group_name                 = azurerm_resource_group.hub.name
  laws_instance_id                    = azurerm_log_analytics_workspace.laws.workspace_id
  environment                         = var.environment # Example "usgovernment"
  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
}

module "tier0-policy-assignment" {
  count = var.create_policy_assignment ? 1 : 0

  providers                           = { azurerm = azurerm.tier0 }
  source                              = "../modules/policy-assignments"
  depends_on                          = [azurerm_resource_group.tier0, azurerm_log_analytics_workspace.laws]
  resource_group_name                 = azurerm_resource_group.tier0.name
  laws_instance_id                    = azurerm_log_analytics_workspace.laws.workspace_id
  environment                         = var.environment # Example "usgovernment"
  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
}

module "tier1-policy-assignment" {
  count = var.create_policy_assignment ? 1 : 0

  providers                           = { azurerm = azurerm.tier1 }
  source                              = "../modules/policy-assignments"
  depends_on                          = [azurerm_resource_group.tier1, azurerm_log_analytics_workspace.laws]
  resource_group_name                 = azurerm_resource_group.tier1.name
  laws_instance_id                    = azurerm_log_analytics_workspace.laws.workspace_id
  environment                         = var.environment # Example "usgovernment"
  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
}

module "tier2-policy-assignment" {
  count = var.create_policy_assignment ? 1 : 0

  providers                           = { azurerm = azurerm.tier2 }
  source                              = "../modules/policy-assignments"
  depends_on                          = [azurerm_resource_group.tier2, azurerm_log_analytics_workspace.laws]
  resource_group_name                 = azurerm_resource_group.tier2.name
  laws_instance_id                    = azurerm_log_analytics_workspace.laws.workspace_id
  environment                         = var.environment # Example "usgovernment"
  log_analytics_workspace_resource_id = azurerm_log_analytics_workspace.laws.id
}
