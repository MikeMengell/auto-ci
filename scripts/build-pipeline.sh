#!/usr/bin/env bash -e

blackbox_postdeploy
#Enter passphrase

cd terraform/providers/kubernetes

terraform init -input=false

#import the gcp project
terraform import google_project.auto-ci $AUTO_CI_PROJECTID

#import the random number generator
#terraform import random_integer.suffix 

terraform plan -out=tfplan -input=false -var-file='variables.tfvars'

terraform apply -input=false tfplan

rm tfplan

#Get output?
#terraform output -json instance_ips | jq '.value[0]'

#Add new k8s as default to kubectl
CLUSTER_NAME="$(terraform output cluster_name)"
gcloud container clusters get-credentials $CLUSTER_NAME  --zone=australia-southeast1-a

#Install service account for helm

#Init helm
