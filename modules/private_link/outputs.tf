output "atlas_endpoint_service_name" {
  description = "The id of atlas endpoint service name"
  value = mongodbatlas_privatelink_endpoint.iac_privatelink_endpoint.private_link_id
}

output "azure_private_endpoint_id" {
  description = "The id of the azure private endpoint"
  value = azurerm_private_endpoint.iac_azure_private_endpoint.id
}