#!/usr/bin/env bash -e

rm -R .terraform

rm -R terraform/providers/kubernetes/.terraform

rm terraform/providers/kubernetes/backend.tf

rm terraform/providers/kubernetes/tfplan

rm terraform/providers/variables.tfvars

blackbox_deregister_file terraform/providers/variables.tfvars
