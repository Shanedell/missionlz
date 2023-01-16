# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
data "azurerm_client_config" "current_client" {
}

################################
### GLOBAL VARIABLES         ###
################################

locals {
  firewall_premium_environments = ["public", "usgovernment"] # terraform azurerm environments where Azure Firewall Premium is supported
}

// Central Logging
locals {
  log_categories = ["Administrative", "Security", "ServiceHealth", "Alert", "Recommendation", "Policy", "Autoscale", "ResourceHealth"]
}
