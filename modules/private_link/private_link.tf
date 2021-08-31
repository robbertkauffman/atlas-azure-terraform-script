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

# ATLAS PRIVATE LINK ENDPOINT
resource "mongodbatlas_privatelink_endpoint" "iac_privatelink_endpoint" {
  project_id    = var.atlas_project_id
  provider_name = "AZURE"
  region        = var.location
}

# AZURE PRIVATE LINK ENDPOINT
resource "azurerm_private_endpoint" "iac_azure_private_endpoint" {
  name                = var.azure_private_link_endpoint_name
  resource_group_name = var.azure_rg
  location            = var.location
  subnet_id           = var.azure_subnet_id

  private_service_connection {
    name                           = var.azure_private_service_connection_name
    private_connection_resource_id = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.private_link_service_resource_id
    is_manual_connection           = true
    request_message                = var.azure_private_service_connection_request_message
  }
}

# ATLAS PRIVATE LINK ENDPOINT SERVICE
resource "mongodbatlas_privatelink_endpoint_service" "iac_privatelink_endpoint_service" {
  project_id                  = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.project_id
  private_link_id             = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.private_link_id
  endpoint_service_id         = azurerm_private_endpoint.iac_azure_private_endpoint.id  
  provider_name               = "AZURE"
  private_endpoint_ip_address = azurerm_private_endpoint.iac_azure_private_endpoint.private_service_connection[0].private_ip_address
}