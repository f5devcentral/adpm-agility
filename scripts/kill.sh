cd ../terraform/deploy/
terraform init && terraform destroy --auto-approve
rm -rf .terraform
rm -rf .terraform.lock.hcl

cd ../student_backend/
rm -rf .terraform
rm -rf .terraform.lock.hcl

cd ../state_setup/
terraform init && terraform destroy --auto-approve
rm -rf .terraform
rm -rf .terraform.lock.hcl
rm -rf terraform.tfstate
rm -rf terraform.tfstate.backup 





