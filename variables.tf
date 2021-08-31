###################
#  MONGO + AZURE  #
###################

variable "locations" {
  description = "Locations/regions and Atlas cluster configuration for that region"
  type = list(object({
    location                              = string
    azure_workload_resource_group_name    = string
    azure_virtual_network_name            = string
    azure_subnet_name                     = string
    azure_private_endpoint_name           = string
    azure_private_service_connection_name = string
    atlas_resource_group_name             = string
    atlas_region                          = string
    atlas_cluster_electable_nodes         = number
    atlas_cluster_priority                = number
    atlas_cluster_read_only_nodes         = number
    atlas_cluster_analytics_nodes         = number
  }))
  default = [
    # Uncomment from here for single-region clusters
    # {
    #   location: "eastus2"
    #   azure_workload_resource_group_name: "mongodb-atlas-poc"
    #   azure_virtual_network_name: "eastus2-workload-vnet"
    #   azure_subnet_name: "default"
    #   azure_private_endpoint_name: "atlas-tf-pe-eastus2"
    #   azure_private_service_connection_name: "atlas-tf-psc-eastus2"
    #   atlas_resource_group_name: "atlas-tf-rg-eastus2"
    #   atlas_region: "US_EAST_2"
    #   atlas_cluster_electable_nodes: 3
    #   atlas_cluster_priority: 7
    #   atlas_cluster_read_only_nodes: 0
    #   atlas_cluster_analytics_nodes: 0
    # }
    # End uncomment for single-region clusters

    # Uncomment from here for multi-region clusters
    {
      location: "eastus2"
      azure_workload_resource_group_name: "mongodb-atlas-poc"
      azure_virtual_network_name: "eastus2-workload-vnet"
      azure_subnet_name: "default"
      azure_private_endpoint_name: "atlas-tf-pe-eastus2"
      azure_private_service_connection_name: "atlas-tf-psc-eastus2"
      atlas_resource_group_name: "atlas-tf-rg-eastus2"
      atlas_region: "US_EAST_2"
      atlas_cluster_electable_nodes: 2
      atlas_cluster_priority: 7
      atlas_cluster_read_only_nodes: 0
      atlas_cluster_analytics_nodes: 0
    },
    {
      location: "westus2"
      azure_workload_resource_group_name: "mongodb-atlas-poc-westus2"
      azure_virtual_network_name: "westus2-workload-vnet"
      azure_subnet_name: "default"
      azure_private_endpoint_name: "atlas-tf-pe-westus2"
      azure_private_service_connection_name: "atlas-tf-psc-westus2"
      atlas_resource_group_name: "atlas-tf-rg-westus2"
      atlas_region: "US_WEST_2"
      atlas_cluster_electable_nodes: 2
      atlas_cluster_priority: 6
      atlas_cluster_read_only_nodes: 0
      atlas_cluster_analytics_nodes: 0
    },
    {
      location: "southcentralus"
      azure_workload_resource_group_name: "mongodb-atlas-poc-southcentralus"
      azure_virtual_network_name: "southcentralus-workload-vnet"
      azure_subnet_name: "default"
      azure_private_endpoint_name: "atlas-tf-pe-southcentralus"
      azure_private_service_connection_name: "atlas-tf-psc-southcentralus"
      atlas_resource_group_name: "atlas-tf-rg-southcentralus"
      atlas_region: "US_SOUTH_CENTRAL"
      atlas_cluster_electable_nodes: 1
      atlas_cluster_priority: 5
      atlas_cluster_read_only_nodes: 0
      atlas_cluster_analytics_nodes: 0
    }
    # End uncomment for multi-region clusters
  ]
}

###################
# MONGODB SECTION #
###################

variable "atlas_project_id" {
  description = "The atlas project to use"
  default     = "PROJECT_ID_HERE"
}

variable "atlas_cluster_name" {
  description = "The name to use for cluster under project"
  default     = "iac-cluster"
}

variable "atlas_cluster_type" {
  description = "Type of Atlas cluster (SHARDED or REPLICASET)"
  default     = "SHARDED"
}

variable "atlas_cluster_encryption" {
  description = "Encryption at rest using a key managed by Azure Key Vault"
}

###################
#      OTHER      #
###################

variable "terraform_server_ip" {
  description = "IP of server running Terraform. Used for setting Key Vault Network ACLs"
  type = string
  # default = "TERRAFORM_IP_HERE"
}