variable "keyvault_name" {
  description = "Name of the Azure Key Vault"
  default = "atlas-tf-kv"
}

variable "keyvault_accesspolicy_principal_objid" {
  description = "Object ID of principal to use in setting kv access policy - Note this comes from Enterprise applications"
  default = "OBJ_ID_HERE"
}

variable "resource_group_name" {
  description = "The azure resource group name to use"
  # Uncomment line below if using existing Azure Key Vault
  # default = "mongodb-atlas-poc"
}

variable "location" {
  description = "The azure location to use"
  # Uncomment line below if using existing Azure Key Vault
  # default = "eastus2"
}

variable "virtual_network_subnet_ids" {
  description = "The virtual network subnet ids"
}

variable "terraform_server_ip" {
  description = "IP of server running Terraform. Used for setting Key Vault Network ACLs"
  type = string
}

variable "atlas_shared_ips" {
  description = "Atlas shared IPs (control plane, etc.): https://docs.atlas.mongodb.com/setup-cluster-security/#required-inbound-access. Used for setting Key Vault Network ACLs"
  type = list
  default = ["18.214.178.145", "18.235.145.62", "18.235.30.157", "18.235.48.235", "34.193.242.51", "34.196.151.229", "34.200.66.236", "34.235.52.68", "35.153.40.82", "35.169.184.216", "35.171.106.60", "35.174.179.65", "35.174.230.146", "35.175.93.3", "35.175.94.38", "35.175.95.59", "52.71.233.234", "52.87.98.128", "107.20.0.247", "107.20.107.166"]
}

variable "atlas_cluster_ips" {
  description = "Atlas cluster IPs. Used for setting Key Vault Network ACLs"
  type = list
  default = []
}