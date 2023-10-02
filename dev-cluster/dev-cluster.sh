cd ./base && terraform init && terraform plan && terraform apply -auto-approve && cd ..
cd ./istio && terraform init && terraform plan && terraform apply -auto-approve && cd ..
cd ./cert-manager && terraform init && terraform plan && terraform apply -auto-approve