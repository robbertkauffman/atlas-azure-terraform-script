# NOTE: Atlas API Keys will not placed in variables.tf,
# export with environment variables only!

terraform {
  required_providers {
    mongodbatlas = {
      version = "0.9.1"
    }
    azurerm = {
      version = "2.74.0"
    }
    dns = {
      version = "3.2.1"
    }
  }
}

provider "mongodbatlas" {
}

provider "azurerm" {
  features {
  }
}

locals {
  # Currently not possible to get CSRS hostnames from the Atlas Provider, 
  # but since these are deterministic can use a regex to generate them using 
  # the RS hostnames
  atlas_rs_hostnames = data.dns_srv_record_set.atlas_srv.srv[*].target
  atlas_csrs_hostnames = [for i in range(3) : 
    replace(local.atlas_rs_hostnames[i], "/shard(-00-0[012]\\.)/", "config$1")
  ]
  # only add CSRS hostnames if sharding is used
  atlas_hostnames = var.atlas_cluster_type == "SHARDED" ? concat(local.atlas_csrs_hostnames, local.atlas_rs_hostnames) : local.atlas_rs_hostnames
}

data "azurerm_client_config" "current" {
}

data "mongodbatlas_project" "atlas_project" {
  project_id   = var.atlas_project_id
}

# Lookup SRV DNS record using Atlas connection string to get a list of hostnames
# See also https://docs.mongodb.com/manual/reference/connection-string/#std-label-connections-dns-seedlist
data "dns_srv_record_set" "atlas_srv" {
  service = replace(module.atlas_cluster.srv_address, "mongodb+srv://", "_mongodb._tcp.")
}

# Resolve Atlas hostnames to IPs
data "dns_a_record_set" "atlas_cluster_ips" {
  for_each = toset(local.atlas_hostnames)
  host = each.key

  depends_on = [module.atlas_cluster]
}

module "atlas_cluster" {
  source = "./modules/atlas_clusters"

  project_id         = data.mongodbatlas_project.atlas_project.project_id
  cluster_name       = var.atlas_cluster_name
  regions            = var.locations
  cluster_type       = var.atlas_cluster_type
  cluster_encryption = var.atlas_cluster_encryption
}

module "atlas_project" {
  source = "./modules/atlas_projects"

  atlas_project_id         = data.mongodbatlas_project.atlas_project.project_id
  atlas_cluster_name       = var.atlas_cluster_name
  azure_rg                 = module.azure_keyvault.resource_group_name
  azure_key_vault_name     = module.azure_keyvault.keyvault_name
  azure_key_identifier     = module.azure_keyvault.key_identifier
  azure_subscription       = data.azurerm_client_config.current.subscription_id
  azure_tenant_id          = data.azurerm_client_config.current.tenant_id
}

module "azure_keyvault" {
  source = "./modules/azure_keyvault"

  # Comment 2 lines below if using existing Key Vault
  resource_group_name        = module.atlas_resgrp_region_1.resourcegroup_name
  location                   = module.atlas_resgrp_region_1.resourcegroup_location
  # Below lines should be configured for new and existing Key Vaults
  virtual_network_subnet_ids = data.azurerm_subnet.workload_region_1.id
  terraform_server_ip        = var.terraform_server_ip
  atlas_cluster_ips          = flatten(toset([
    for host in data.dns_a_record_set.atlas_cluster_ips : host.addrs[0]
  ]))
}

data "azurerm_subnet" "workload_region_1" {
  name                 = var.locations[0].azure_subnet_name
  virtual_network_name = var.locations[0].azure_virtual_network_name
  resource_group_name  = var.locations[0].azure_workload_resource_group_name
}

# Terraform 0.12 doesn't support for_each for modules so will have to use 
# multiple module blocks for multi-region clusters
module "atlas_resgrp_region_1" {
  source   = "./modules/azure_resourcegroups"
  name     = var.locations[0].atlas_resource_group_name
  location = var.locations[0].location
}

module "private_link_region_1" {
  source = "./modules/private_link"

  atlas_project_id                      = data.mongodbatlas_project.atlas_project.project_id
  location                              = var.locations[0].location
  azure_rg                              = var.locations[0].atlas_resource_group_name
  azure_private_link_endpoint_name      = var.locations[0].azure_private_endpoint_name
  azure_private_service_connection_name = var.locations[0].azure_private_service_connection_name
  azure_subnet_id                       = data.azurerm_subnet.workload_region_1.id
}

# # Uncomment this block for multi-region clusters
# data "azurerm_subnet" "workload_region_2" {
#   name                 = var.locations[1].azure_subnet_name
#   virtual_network_name = var.locations[1].azure_virtual_network_name
#   resource_group_name  = var.locations[1].azure_workload_resource_group_name
# }

# # Uncomment this block for multi-region clusters
# module "atlas_resgrp_region_2" {
#   source   = "./modules/azure_resourcegroups"
#   name     = var.locations[1].atlas_resource_group_name
#   location = var.locations[1].location
# }

# # Uncomment this block for multi-region clusters
# module "private_link_region_2" {
#   source = "./modules/private_link"

#   atlas_project_id                      = data.mongodbatlas_project.atlas_project.project_id
#   location                              = var.locations[1].location
#   azure_rg                              = var.locations[1].atlas_resource_group_name
#   azure_private_link_endpoint_name      = var.locations[1].azure_private_endpoint_name
#   azure_private_service_connection_name = var.locations[1].azure_private_service_connection_name
#   azure_subnet_id                       = data.azurerm_subnet.workload_region_2.id
# }

# # Uncomment this block for multi-region clusters
# data "azurerm_subnet" "workload_region_3" {
#   name                 = var.locations[2].azure_subnet_name
#   virtual_network_name = var.locations[2].azure_virtual_network_name
#   resource_group_name  = var.locations[2].azure_workload_resource_group_name
# }

# # Uncomment this block for multi-region clusters
# module "atlas_resgrp_region_3" {
#   source   = "./modules/azure_resourcegroups"
#   name     = var.locations[2].atlas_resource_group_name
#   location = var.locations[2].location
# }

# # Uncomment this block for multi-region clusters
# module "private_link_region_3" {
#   source = "./modules/private_link"

#   atlas_project_id                      = data.mongodbatlas_project.atlas_project.project_id
#   location                              = var.locations[2].location
#   azure_rg                              = var.locations[2].atlas_resource_group_name
#   azure_private_link_endpoint_name      = var.locations[2].azure_private_endpoint_name
#   azure_private_service_connection_name = var.locations[2].azure_private_service_connection_name
#   azure_subnet_id                       = data.azurerm_subnet.workload_region_3.id
# }