output "connection_strings" {
  description = "All Atlas connection strings"
  value = mongodbatlas_cluster.iac_cluster.connection_strings
}

output "srv_address" {
  description = "Atlas SRV connection string"
  value = mongodbatlas_cluster.iac_cluster.srv_address
}