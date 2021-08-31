output "keyvault_name" {
  description = "Name of the Azure Key Vault"
  value = azurerm_key_vault.iac_keyvault.name
}

output "keyvault_id" {
  description = "ID of the Azure Key Vault"
  value = azurerm_key_vault.iac_keyvault.id
}

output "key_identifier" {
  description = "The key identifier"
  value = azurerm_key_vault_key.iac_atlas_key.id
}

output "keyvault_uri" {
  description = "URL of the keyvault for Atlas use downstream"
  value = azurerm_key_vault.iac_keyvault.vault_uri
}

output "resource_group_name" {
  description = "Name of Resource Group Keyvault is part of"
  value = azurerm_key_vault.iac_keyvault.resource_group_name
}

output "location" {
  description = "Location of Keyvault"
  value = azurerm_key_vault.iac_keyvault.location
}