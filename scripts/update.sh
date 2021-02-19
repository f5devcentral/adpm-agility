cd ../workflow_automation/state_setup/
terraform init && terraform apply --auto-approve
sleep 10s

cd ../deploy/
terraform init && terraform plan && terraform apply --auto-approve