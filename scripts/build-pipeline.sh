#!/usr/bin/env bash -e

blackbox_postdeploy
#Enter passphrase

cd terraform/providers/kubernetes

terraform init -input=false

#import the gcp project
terraform import google_project.auto-ci $AUTO_CI_PROJECTID

#import the random number generator
#terraform import random_integer.suffix 

terraform plan -out=tfplan -input=false

terraform apply -input=false tfplan

#Add new k8s as default to kubectl

#Install service account for helm

#Init helm
