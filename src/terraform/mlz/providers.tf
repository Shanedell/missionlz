# Copyright (c) Microsoft Corporation.
# Licensed under the MIT License.
terraform {
  # It is recommended to use remote state instead of local
  # If you are using Terraform Cloud, You can update these values in order to configure your remote state.
  /*  backend "remote" {
    organization = "{{ORGANIZATION_NAME}}"
    workspaces {
      name = "{{WORKSPACE_NAME}}"
    }
  }
  */
  backend "local" {}

  required_version = ">= 1.2.9"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "= 3.23.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "= 3.4.3"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.8.0"
    }
  }
}

provider "azurerm" {
  environment     = var.environment
  metadata_host   = var.metadata_host
  subscription_id = var.hub_subid

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "hub"
  environment     = var.environment
  metadata_host   = var.metadata_host
  subscription_id = var.hub_subid

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "tier0"
  environment     = var.environment
  metadata_host   = var.metadata_host
  subscription_id = coalesce(var.tier0_subid, var.hub_subid)

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "tier1"
  environment     = var.environment
  metadata_host   = var.metadata_host
  subscription_id = coalesce(var.tier1_subid, var.hub_subid)

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "azurerm" {
  alias           = "tier2"
  environment     = var.environment
  metadata_host   = var.metadata_host
  subscription_id = coalesce(var.tier2_subid, var.hub_subid)

  features {
    log_analytics_workspace {
      permanently_delete_on_destroy = true
    }
    key_vault {
      purge_soft_delete_on_destroy = true
    }
  }
}

provider "random" {
}

provider "time" {
}
