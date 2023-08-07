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
    environment      = var.environment
    location         = var.location
    plan_name        = "plan-tfdemoone-${local.environment}"
    application_name = "fn-tfdemoone-${local.environment}"
    resource_group   = "rg-tfdemoone-${local.environment}"
    storage_account  = "satfdemoone${local.environment}"
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

# create the storage account for hosting the function app
resource "azurerm_storage_account" "example" {
  name                     = local.storage_account
  resource_group_name      = azurerm_resource_group.main.name
  location                 = azurerm_resource_group.main.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

# creating app service plan for hosting the function app
resource "azurerm_app_service_plan" "example" {
  name                = local.plan_name
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location

  kind  = "Linux"
  reserved = true

  tags = {
    "environment" = local.environment
  }

  sku {
    tier = "Standard"
    size = "S1"
  }
}

# creating function app
resource "azurerm_function_app" "example" {
  name                       = local.application_name
  location                   = azurerm_resource_group.main.location
  resource_group_name        = azurerm_resource_group.main.name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = azurerm_storage_account.example.name
  storage_account_access_key = azurerm_storage_account.example.primary_access_key
  os_type                    = "linux"

  tags = {
    "environment" = local.environment
  }
}