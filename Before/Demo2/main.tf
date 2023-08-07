# declare the required providers
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "2.68.0"
    }
  }
}

# declare the provider
provider "azurerm" {
  features {}
}

# declare local variables
locals {
  environment    = var.environment
  location       = var.location
  resource_group = "rg-tfdemoone-${local.environment}"
}

# create the resource group for hosting the function apps
resource "azurerm_resource_group" "main" {
  name     = local.resource_group
  location = local.location

  tags = {
    "terraform"   = "true"
    "environment" = local.environment
  }
}

# create data source for pre existing storage account
data "azurerm_storage_account" "example" {
  name                = "venutestaccount"
  resource_group_name = "ADFTransformationVenu"
}

# calling functionapp module with required inputs
module "main" {
  source              = "./modules/functionapp"
  rg_name             = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  environment         = local.environment
  sa_name             = data.azurerm_storage_account.example.name
  sa_key              = data.azurerm_storage_account.example.primary_access_key
  number_of_instances = 2
}