#!/bin/sh

terraform init
terraform apply -var-file=".terraform.tfvars"
