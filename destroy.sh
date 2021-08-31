#!/bin/bash

# Disable Atlas cluster-encryption first because Project-level encryption can't
# be disabled while cluster-encryption is enabled. And Atlas cluster can't be
# removed as Terraform will try to remove it's dependencies first such as
# Project-level encryption creating a circular dependency
terraform apply --auto-approve -target=module.atlas_cluster -var="atlas_cluster_encryption=NONE"
# Abort if Terraform wasn't able to disable cluster-encryption
if [ $? -ne 0 ]; then
  echo "Aborting due to last command returning an error (non-zero)"
  exit
fi

# Destroy all resources
terraform destroy --auto-approve -var="atlas_cluster_encryption=NONE"