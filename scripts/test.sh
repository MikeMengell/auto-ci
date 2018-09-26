#Encrypt the secrets if variables.tfvars doesn't already exist
if blackbox_list_files | grep -q "terraform/providers/variables.tfvars"; then
  echo "file exists in blackbox"
else
  echo "not found"
  blackbox_register_new_file terraform/providers/variables.tfvars
fi