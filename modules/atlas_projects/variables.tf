# Uncomment below if you want Terraform to create the Atlas project instead of 
# using an existing Project.
# Make sure to uncomment lines 16-21 in atlas_projects.tf as well
# variable "organization" {
#   description = "Name of Atlas organization to use"
#   default = "5ff3752afc8239217272c10a"
# }

# variable "atlas_project_name" {
#   description = "Name of the Atlas Project to create"
#   default = "IaC-TF"
# }

variable "atlas_project_id" {
  description = "ID of the existing Atlas Project"
}

variable "atlas_cluster_name" {
  description = "Name of Atlas Cluster to create"
}

variable "db_username" {
  description = "Username of database user to create"
  default = "root2"
}

variable "db_password" {
  description = "Password of database user to create"
  default = "root"
}

variable "db_role" {
  description = "Role to assign to database user"
  default = "readWrite"
}

variable "db_name" {
  description = "Database name that role is applied to"
  default = "myAppDb"
}

variable "azure_rg" {
  description = "Name of azure resource group to use"
}

variable "azure_key_vault_name" {
  description = "Name of azure key vault to use"
}

variable "azure_key_identifier" {
  description = "Name of azure key to use"
}

variable "azure_subscription" {
  description = "Name of azure subscription to use"
}

variable "azure_tenant_id" {
  description = "Name of azure tenant id"
}

variable "azure_authentication_secret" {
  description = "Password to be used when connecting Atlas to Azure Key Vault - For prod better to fetch or use env variable"
  default = "SECRET_HERE"
}

variable "azure_keyvault_accesspolicy_principal_appid" {
  description = "Application ID of principal to use in setting kv access policy"
  default = "APP_ID_HERE"
}