variable "atlas_project_id" {
  description = "ID of Atlas Project"
}

variable "location" {
  description = "Location/region where resources are deployed to"
}

variable "azure_rg" {
  description = "Name of azure resource group to use"
}

variable "azure_subnet_id" {
  description = "Subnet id from azure virtual network"
}

variable "azure_private_link_endpoint_name" {
  description = "Name of the Azure private endpoint"
}

variable "azure_private_service_connection_name" {
  description = "Name of the private service connection in private endpoint"
}

variable "azure_private_service_connection_request_message" {
  description = "Request messsage to include with private service connection in private endpoint"
  default = "Atlas Azure Private Link Connection"
}