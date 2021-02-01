cd ../terraform/deploy/
terraform init && terraform destroy --auto-approve

cd ../state_setup/
terraform init && terraform destroy --auto-approve


