cd ../terraform/bigip_2nic_deploy/
terraform init && terraform destroy --auto-approve

cd ../student_backend/
terraform init && terraform destroy --auto-approve

cd ../state_setup/
terraform init && terraform destroy --auto-approve


