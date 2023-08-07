variable "rg_name" {
  type = string
  description = "RG Name for all resources"
}

variable "location" {
  type = string
  description = "Location for all resources"
}

variable "environment" {
  type = string
  description = "Environment of Deployment"
}

variable "sa_name" {
  type = string
  description = "Storage Account Name"
}

variable "sa_key" {
  type = string
  description = "Storage Account Key"
  sensitive = true
}

variable "number_of_instances" {
  type = number
  description = "Count of instances to deploy"
}

variable "configurations" {
  type = list(map(string))
  default = [
    {
        "name" = "dev",
        "tier" = "Standard",
        "size" = "S2"
    },
    {
        "name" = "qa",
        "tier" = "Standard",
        "size" = "S1"
    }
  ]
}

variable "function_names" {
  type = list(string)
  default = [
    "fn-tfdemoone-001",
    "fn-tfdemoone-002"
  ]
}