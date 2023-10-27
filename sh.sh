#!/bin/sh

terraform init
terraform apply -var-file="secrets_example.tfvars" -var-file=".terraform_example.tfvars"
