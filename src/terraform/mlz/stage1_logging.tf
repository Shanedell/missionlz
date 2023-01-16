# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### STAGE 1: Logging         ###
################################

resource "random_id" "laws" {
  keepers = {
    resource_group = azurerm_resource_group.tier1.name
  }

  byte_length = 8
}

resource "azurerm_log_analytics_workspace" "laws" {
  provider   = azurerm.tier1
  depends_on = [random_id.laws]

  name                = coalesce(var.log_analytics_workspace_name, format("%.24s", lower(replace("logAnalyticsWorkspace${random_id.laws.hex}", "/[[:^alnum:]]/", ""))))
  resource_group_name = azurerm_resource_group.tier1.name
  location            = var.location
  sku                 = "PerGB2018"
  retention_in_days   = "30"
  tags                = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_log_analytics_solution" "laws_sentinel" {
  provider = azurerm.tier1
  count    = var.create_sentinel ? 1 : 0

  solution_name         = "SecurityInsights"
  location              = azurerm_resource_group.tier1.location
  resource_group_name   = azurerm_resource_group.tier1.name
  workspace_resource_id = azurerm_log_analytics_workspace.laws.id
  workspace_name        = azurerm_log_analytics_workspace.laws.name

  plan {
    publisher = "Microsoft"
    product   = "OMSGallery/SecurityInsights"
  }
  tags = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_monitor_diagnostic_setting" "hub-central" {
  provider           = azurerm.hub
  name               = "hub-central-diagnostics"
  target_resource_id = "/subscriptions/${var.hub_subid}"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws.id

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

resource "azurerm_monitor_diagnostic_setting" "tier0-central" {
  count              = (var.tier0_subid != "") ? (var.tier0_subid != var.hub_subid ? 1 : 0) : 0
  provider           = azurerm.tier0
  name               = "tier0-central-diagnostics"
  target_resource_id = "/subscriptions/${var.tier0_subid}"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws.id

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

resource "azurerm_monitor_diagnostic_setting" "tier1-central" {
  count              = (var.tier1_subid != "") ? (var.tier1_subid != var.hub_subid ? 1 : 0) : 0
  provider           = azurerm.tier1
  name               = "tier1-central-diagnostics"
  target_resource_id = "/subscriptions/${var.tier1_subid}"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws.id

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

resource "azurerm_monitor_diagnostic_setting" "tier2-central" {
  count              = (var.tier2_subid != "") ? (var.tier2_subid != var.hub_subid ? 1 : 0) : 0
  provider           = azurerm.tier2
  name               = "tier2-central-diagnostics"
  target_resource_id = "/subscriptions/${var.tier2_subid}"

  log_analytics_workspace_id = azurerm_log_analytics_workspace.laws.id

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
