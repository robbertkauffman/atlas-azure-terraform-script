# Create resource group to hold all builds and resources
resource "azurerm_resource_group" "iac_rg" {
  name     = var.name
  location = var.location 
}