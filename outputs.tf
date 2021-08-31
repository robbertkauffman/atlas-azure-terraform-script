output "atlas_connection_strings" {
  description = "All Atlas connection strings"
  value       = module.atlas_cluster.connection_strings
}

output "atlas_srv_connection_string" {
  description = "Atlas SRV connection string"
  value = module.atlas_cluster.srv_address
}

output "atlas_cluster_ips" {
  description = "Atlas cluster IPs. Used for setting Key Vault Network ACLs"
  value = flatten(toset([
    for host in data.dns_a_record_set.atlas_cluster_ips : host.addrs[0]
  ]))
}