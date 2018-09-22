#!/usr/bin/env bash -e

#Based on https://github.com/steinim/gcp-terraform-workshop

#secrets are located in config.sh - encrypted using blackbox
#source ./config.sh
#complete version which takes into account any bash source file location
DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$DIR" ]]; then DIR="$PWD"; fi
. "$DIR/config.sh"

#Need to setup environment variables - or secrets one day.
# export GOOGLE_REGION=europe-west3 # change this if you want to use a different region
# export TF_VAR_org_id=<your_org_id>
# export TF_VAR_billing_account=<your_billing_account_id>
# export TF_VAR_region=${GOOGLE_REGION}
# export TF_VAR_user=${USER}
# export TF_VAR_ssh_key=<path_to_your_public_ssh_key>
# export TF_ADMIN=${USER}-tf-admin
# export TF_CREDS=~/.config/gcloud/${USER}-tf-admin.json

#Create the Terraform admin project
#This is where remote state will be configured

projectid=${TF_ADMIN}-${RANDOM}

export AUTO_CI_PROJECTID=${projectid}

gcloud projects create ${projectid} \
  --organization ${TF_VAR_org_id} \
  --set-as-default

#Need to enable beta billing components
# gcloud beta services enable billing

gcloud beta billing projects link ${projectid} \
  --billing-account ${TF_VAR_billing_account}


#Create service accounts
gcloud iam service-accounts create terraform \
  --display-name "Terraform admin account"

gcloud iam service-accounts keys create ${TF_CREDS} \
  --iam-account terraform@${projectid}.iam.gserviceaccount.com

export GOOGLE_APPLICATION_CREDENTIALS=${TF_CREDS}

#Enable service account (keyfile was downloaded when the service account was created)
#gcloud auth activate-service-account --key-file=${TF_CREDS}

#Grant service access to storage
gcloud projects add-iam-policy-binding ${projectid} \
  --member serviceAccount:terraform@${projectid}.iam.gserviceaccount.com \
  --role roles/viewer

gcloud projects add-iam-policy-binding ${projectid} \
  --member serviceAccount:terraform@${projectid}.iam.gserviceaccount.com \
  --role roles/storage.admin

gcloud projects add-iam-policy-binding ${projectid} \
  --member serviceAccount:terraform@${projectid}.iam.gserviceaccount.com \
  --role roles/container.admin

gcloud projects add-iam-policy-binding ${projectid} \
  --member serviceAccount:terraform@${projectid}.iam.gserviceaccount.com \
  --role roles/iam.serviceAccountUser

#Enable required services
gcloud services enable cloudresourcemanager.googleapis.com
gcloud services enable cloudbilling.googleapis.com
gcloud services enable iam.googleapis.com
gcloud services enable compute.googleapis.com
gcloud services enable sqladmin.googleapis.com
gcloud services enable container.googleapis.com

# #If a .terraform folder exists then delete as building a clean state
# if [ ! -d .terraform ]; then
#   rm -R .terraform;
# fi

gsutil mb -l ${TF_VAR_region} -p ${projectid} gs://${projectid}

cat > terraform/providers/kubernetes/backend.tf <<EOF
terraform {
 backend "gcs" {
   bucket = "${projectid}"
   prefix  = "terraform/state/infra"
 }
}
EOF

cat > terraform/providers/variables.tfvars <<EOF
{
    "name": "${projectid}",
    "project_id": "${projectid}",
    "org_id": "${TF_VAR_org_id}",
    "billing_account": "${TF_VAR_billing_account}"
}
EOF

#Encrypt the secrets
blackbox_register_new_file terraform/providers/variables.tfvars
