# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### STAGE 1: Logging         ###
################################

data "azurerm_log_analytics_workspace" "laws" {
  provider = azurerm.tier1

  name                = var.laws_name
  resource_group_name = var.laws_rgname
}

// Central Logging
locals {
  log_categories = ["Administrative", "Security", "ServiceHealth", "Alert", "Recommendation", "Policy", "Autoscale", "ResourceHealth"]
}

resource "azurerm_monitor_diagnostic_setting" "tier3-central" {
  count              = var.tier3_subid != var.hub_subid ? 1 : 0
  provider           = azurerm.tier3
  name               = "tier3-central-diagnostics"
  target_resource_id = "/subscriptions/${var.tier3_subid}"

  log_analytics_workspace_id = data.azurerm_log_analytics_workspace.laws.id

  dynamic "log" {
    for_each = local.log_categories
    content {
      category = log.value
      enabled  = true

      retention_policy {
        days    = 0
        enabled = false
      }
    }
  }
}
