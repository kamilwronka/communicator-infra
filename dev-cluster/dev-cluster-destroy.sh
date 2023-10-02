cd ./istio && terraform init && terraform destroy -auto-approve && cd ..
cd ./base && terraform init && terraform destroy -auto-approve && cd ..
cd ./cert-manager && terraform init && terraform destroy -auto-approve
