terraform {
  required_providers {
    mongodbatlas = {
      version = "0.9.1"
    }
  }
}

# CLUSTERS - Create the cluster in the project 
# Create a new cluster
resource "mongodbatlas_cluster" "iac_cluster" {
  # CLUSTER SPECIFICS - name, clustertype, region and replicaset info
  project_id   = var.project_id
  name         = var.cluster_name
  cluster_type = var.cluster_type
  replication_specs {
    num_shards = 1
    dynamic "regions_config" {
      for_each = var.regions
      content {
        region_name     = regions_config.value.atlas_region
        electable_nodes = regions_config.value.atlas_cluster_electable_nodes
        priority        = regions_config.value.atlas_cluster_priority
        read_only_nodes = regions_config.value.atlas_cluster_read_only_nodes
        analytics_nodes = regions_config.value.atlas_cluster_analytics_nodes
      }
    }
  }

  # CLUSTER CLOUD PROVIDER - Set cloud provider specifics
  provider_name               = var.cloud_provider
  # M30 is required for a sharded cluster, change cluster tier to M30 if M10 or M20 is used for a sharded cluster 
  provider_instance_size_name = (var.cluster_tier == "M10" || var.cluster_tier == "M20") && var.cluster_type == "SHARDED" ? "M30" : var.cluster_tier
  provider_disk_type_name     = var.disk_size
  
  # CLUSTER AUTO SCALING - Disk scaling is enabled by default. It is safe to 
  # comment out the auto_scaling_compute block if not concerned about CPU scaling. 
  # NOTE: If you comment out auto_scaling_compute ensure you comment out the 
  # lifecycle block as well. 
  
  auto_scaling_disk_gb_enabled = var.auto_scaling_disk_gb_enabled
  
  # auto_scaling_compute_enabled = false
  
  # CLUSTER - LIFECYCLE RESOURCES - This is needed for auto_scaling_compute. 
  # If not using auto scaling settings you can comment the lifecycle block out. 
  # If you were to run a terraform plan/apply and Atlas had scaled prior 
  # automatically, terraform would try to reset the cluster back to what 
  # matched in configuration. If you need to manually/explicitly change the 
  # cluster size comment out the lifecycle block and then run terraform 
  # plan/apply.
  # lifecycle {
  #     ignore_changes = [ provider_instance_size_name, provider_disk_type_name,]
  # }
  
  mongo_db_major_version = var.major_version

  provider_backup_enabled = var.provider_backup_enabled
  pit_enabled  = var.pit_enabled

  # ENCRYPTION AT REST - Set for client managed keys for encryption at rest
  encryption_at_rest_provider = var.cluster_encryption
}