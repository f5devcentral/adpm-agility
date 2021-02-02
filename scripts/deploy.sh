cd ../terraform/state_setup/
terraform init && terraform plan && terraform apply --auto-approve
sleep 10s

cd ../student_backend/
terraform init && terraform plan && terraform apply --auto-approve
sleep 10s

cd ../deploy/
terraform init && terraform plan && terraform apply --auto-approve
