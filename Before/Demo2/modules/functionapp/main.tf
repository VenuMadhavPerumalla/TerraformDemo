locals {
    plan_name        = format("%s-%s", "plan-tfdemoone", var.environment)
}

# creating app service plan for hosting multiple function apps
resource "azurerm_app_service_plan" "example" {
  name                = local.plan_name
  resource_group_name = var.rg_name
  location            = var.location

  kind  = "Linux"
  reserved = true

  tags = {
    "environment" = var.environment
  }

  # terraform functions
  # lookup - retrieves the value of given field in a map
  # element - retrieves the value of element at a given positions from a list
  # index - retrieves the index of a given value in a list
  # format - formats a string according to the given format
  sku {
    tier = lookup(var.configurations[index(var.configurations.*.name, var.environment)], "tier")
    size = lookup(var.configurations[index(var.configurations.*.name, var.environment)], "size")
  }
}

# creating function apps using count which is fed as input from caller module
# name of function apps can be derived using count.index
resource "azurerm_function_app" "example" {
  count                      = var.number_of_instances
  name                       = element(var.function_names, count.index)
  location                   = var.location
  resource_group_name        = var.rg_name
  app_service_plan_id        = azurerm_app_service_plan.example.id
  storage_account_name       = var.sa_name
  storage_account_access_key = var.sa_key
  os_type                    = "linux"

  tags = {
    "environment" = var.environment
  }
}