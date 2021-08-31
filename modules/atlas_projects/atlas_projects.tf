terraform {
  required_providers {
    mongodbatlas = {
      version = "0.9.1"
    }
    azurerm = {
      version = "2.74.0"
    }
  }
}

# Uncomment below if you want Terraform to create the Atlas project instead of using an existing Project
# make sure to uncomment lines 3-11 in variables.tf as well, and fill in your Atlas Organization ID
# # PROJECT - Create the Atlas project that our clusters will run in
# # Create a new project for cluster placement
# resource "mongodbatlas_project" "iac_project" {
#   name   = var.atlas_project_name
#   org_id = var.organization
# }

# PROJECT - AZURE KEY VAULT - Enable encryption at rest using customer key management
resource "mongodbatlas_encryption_at_rest" "key_vault" {
  project_id = var.atlas_project_id

  azure_key_vault = {
    enabled             = true
    client_id           = var.azure_keyvault_accesspolicy_principal_appid 
    azure_environment   = "AZURE"
    subscription_id     = var.azure_subscription
    resource_group_name = var.azure_rg
    key_vault_name      = var.azure_key_vault_name 
    key_identifier      = var.azure_key_identifier
    secret              = var.azure_authentication_secret
    tenant_id           = var.azure_tenant_id
  }
}

# PROJECT - DATABASE ACCESS
resource "mongodbatlas_database_user" "admin" {
  username           = var.db_username
  password           = var.db_password
  project_id         = var.atlas_project_id
  auth_database_name = "admin"

  roles {
    role_name     = var.db_role
    database_name = var.db_name
  }

  # roles {
  #   role_name     = "readAnyDatabase"
  #   database_name = "admin"
  # }

  scopes {
    name = var.atlas_cluster_name
    type = "CLUSTER"
  }
}