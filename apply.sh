#!/bin/bash

stop_on_error() {
  if [ $? -ne 0 ]; then
    echo "Aborting due to last command returning an error (non-zero)"
    exit
  fi
}

# Azure Key Vault should restrict access to allowed IPs only which means the 
# Atlas cluster needs to be created first and without encryption, so that the
# cluster IPs can be obtained. And added to the Key Vault Network ACLs on a 
# subsequent run. Otherwise cluster creation could hang as it won't be able to 
# obtain the encryption keys from Azure Key Vault
terraform apply --auto-approve -target=module.atlas_cluster -var="atlas_cluster_encryption=NONE"
# Abort if Terraform didn't complete cluster creation
stop_on_error

# Create rest of resources
terraform apply --auto-approve -var="atlas_cluster_encryption=NONE"
stop_on_error

# Now that Azure Key Vault Network ACLs have been set and encryption has been
# enabled on the Atlas-project, enable cluster-encryption
# Cannot be done as part of previous run as this would create a circular 
# dependency
terraform apply --auto-approve -target=module.atlas_cluster -var="atlas_cluster_encryption=AZURE"