#!/usr/bin/env bash -e

gcloud container clusters delete $CLUSTER_NAME --zone=australia-southeast1-a --quiet
#Removes cluster from kubectl creds too

gcloud projects delete $AUTO_CI_PROJECTID --quiet

rm -R .terraform

rm -R terraform/providers/kubernetes/.terraform

rm terraform/providers/kubernetes/backend.tf

rm terraform/providers/kubernetes/tfplan

blackbox_deregister_file terraform/providers/kubernetes/variables.tfvars.gpg

rm terraform/providers/kubernetes/variables.tfvars

#rm terraform/providers/variables.tfvars.gpg
