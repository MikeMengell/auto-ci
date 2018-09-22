#!/usr/bin/env bash -e

rm -R .terraform

rm -R terraform/providers/kubernetes/.terraform

rm terraform/providers/kubernetes/backend.tf

rm terraform/providers/kubernetes/project.tf

rm terraform/providers/kubernetes/tfplan

rm terraform/providers/variables.tfvars

rm terraform/providers/variables.tfvars.gpg
