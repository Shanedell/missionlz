# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.

################################
### STAGE 0: Scaffolding     ###
################################
resource "random_id" "random" {
  keepers = {
    # Generate a new id each time we change resourePrefix variable
    resourcePrefix = var.resourcePrefix
  }
  byte_length = 8
}

resource "azurerm_resource_group" "hub" {
  provider   = azurerm.hub
  depends_on = [random_id.random]

  location = var.location
  name     = "${var.resourcePrefix}-${random_id.random.hex}-${var.hub_rgname}"
  tags     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_resource_group" "tier0" {
  provider   = azurerm.tier0
  depends_on = [random_id.random]

  location = var.location
  name     = "${var.resourcePrefix}-${random_id.random.hex}-${var.tier0_rgname}"
  tags     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_resource_group" "tier1" {
  provider   = azurerm.tier1
  depends_on = [random_id.random]

  location = var.location
  name     = "${var.resourcePrefix}-${random_id.random.hex}-${var.tier1_rgname}"
  tags     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}

resource "azurerm_resource_group" "tier2" {
  provider   = azurerm.tier2
  depends_on = [random_id.random]

  location = var.location
  name     = "${var.resourcePrefix}-${random_id.random.hex}-${var.tier2_rgname}"
  tags     = merge(var.tags, { "resourcePrefix" = "${var.resourcePrefix}-${random_id.random.hex}" })
}
