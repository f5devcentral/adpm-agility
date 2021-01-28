cd ../terraform/bigip_2nic_deploy/
terraform destroy --auto-approve

cd ../student_backend/
terraform destroy --auto-approve

cd ../state_setup/
terraform destroy --auto-approve


