# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### STAGE 0: Scaffolding     ###
################################

resource "azurerm_resource_group" "tier3" {
  provider = azurerm.tier3

  location = var.location
  name     = var.tier3_rgname
  tags     = var.tags
}
