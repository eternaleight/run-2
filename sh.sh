#!/bin/sh

terraform init
terraform apply -var-file="secrets.tfvars" -var-file=".terraform.tfvars"
