output "resourcegroup_location" {
  description = "Resource group location"
  value = azurerm_resource_group.iac_rg.location
}

output "resourcegroup_name" {
  description = "Resource group name"
  value = azurerm_resource_group.iac_rg.name
}