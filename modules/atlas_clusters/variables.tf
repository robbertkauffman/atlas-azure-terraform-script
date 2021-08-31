variable "project_id" {
  description = "Atlas project id to deploy clusters into"
}

variable "cluster_name" {
  description = "The name to use for cluster under project"
}

variable "cloud_provider" {
  description = "The cloud provider to place cluster in - AWS / Azure / GCP"
  default     = "AZURE"
}

variable "regions" {
  description = "The regions in which to place the cluster and their respective configuration"
}

variable "cluster_type" {
  description = "The cluster type: replica set or sharded"
}

variable "cluster_tier" {
  description = "The cluster tier size you desire - eg M30, M40, etc"
  default = "M10"
}

variable "disk_size" {
  description = "The cluster disk size to initialize with in GB"
  default = "P4"
}

variable "auto_scaling_disk_gb_enabled" {
  description = "Specifies whether disk auto-scaling is enabled. The default is true. If storage exceeds 90% of disk capacity, auto-expand to maintain <70%. If maximum capacity is reached, auto-scale to the next cluster tier (e.g. M30 to M40)"
  default = true
}

variable "major_version" {
  description = "Version of the cluster to deploy"
  default = "4.4"
}

variable "provider_backup_enabled" {
  description = " Flag indicating if the cluster uses Cloud Backup for backups"
  default = true
}

variable "pit_enabled" {
  description = "Flag that indicates if the cluster uses Continuous Cloud Backup. If set to true, provider_backup_enabled must also be set to true"
  default = true
}

variable "cluster_encryption" {
  description = "Encryption at rest using a key managed by Azure Key Vault"
}