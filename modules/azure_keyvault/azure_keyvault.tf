# DATA SOURCES

# Data source to access the configuration of the AzureRM provider
data "azurerm_client_config" "current" {
}

# Create Azure Key Vault for use with MongoDB Atlas operations
# Note: If you already have a key vault, you could change the values below to 
# match your currently deployed environment and then use terraform import to 
# bring that key vault into state. See readme for more details
resource "azurerm_key_vault" "iac_keyvault" {
  name                        = var.keyvault_name
  location                    = var.location
  resource_group_name         = var.resource_group_name 
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  sku_name                    = "standard"

  network_acls {
    # Default action if no rules match from ip_rules or virtual network subnet ids
    # Values are "Allow" or "Deny"
    default_action = "Deny"

    # Allow Azure services to bypass network acls or not. Values are "AzureZerivces" or "None"
    bypass = "AzureServices"

    # The list of allowed ip addresses
    ip_rules = concat([var.terraform_server_ip], var.atlas_shared_ips, var.atlas_cluster_ips)

    # Allow our virtual_network_subnet access to this Key Vault
    virtual_network_subnet_ids = [var.virtual_network_subnet_ids] 
  }
}

resource "azurerm_role_assignment" "keyvault_reader_role" {
  scope                = azurerm_key_vault.iac_keyvault.id
  role_definition_name = "Key Vault Reader"
  principal_id         = var.keyvault_accesspolicy_principal_objid
}

resource "azurerm_key_vault_access_policy" "iac_keyvault_atlas_policy" {
  key_vault_id = azurerm_key_vault.iac_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = var.keyvault_accesspolicy_principal_objid

  key_permissions = [
    "get",
    "list",
    "encrypt",
    "decrypt"
  ]
}

resource "azurerm_key_vault_access_policy" "iac_keyvault_user_policy" {
  key_vault_id = azurerm_key_vault.iac_keyvault.id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = data.azurerm_client_config.current.object_id

  key_permissions = [
    "create",
    "decrypt",
    "delete",
    "encrypt",
    "get",
    "import",
    "list",
    "unwrapKey",
    "update",
    "purge",
    "wrapKey"
  ]

  secret_permissions = [
    "backup",
    "delete",
    "get",
    "list",
    "purge",
    "recover",
    "restore",
    "set"
  ]
}

resource "azurerm_key_vault_key" "iac_atlas_key" {
  name         = "atlas-generated-key"
  key_vault_id = azurerm_key_vault.iac_keyvault.id
  key_type     = "RSA"
  key_size     = 2048

  key_opts = [
    "decrypt",
    "encrypt",
    "sign",
    "unwrapKey",
    "verify",
    "wrapKey",
  ]

  depends_on = [
    azurerm_key_vault.iac_keyvault,
    azurerm_role_assignment.keyvault_reader_role,
    azurerm_key_vault_access_policy.iac_keyvault_atlas_policy,
    azurerm_key_vault_access_policy.iac_keyvault_user_policy
  ]
}