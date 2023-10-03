export TF_VAR_kube_config_path=~/.kube/config
export TF_VAR_cert_issuer_email=example@email.com
export TF_VAR_environment=dev
export TF_VAR_project_name=communicator
export TF_VAR_aws_region=$AWS_REGION
export TF_VAR_aws_access_key_id=$AWS_ACCESS_KEY_ID
export TF_VAR_aws_secret_access_key=$AWS_SECRET_ACCESS_KEY
export TF_VAR_cors_origins='["http://localhost:3000"]'
export TF_VAR_cdn_url=$CDN_URL

# Cluster configuration

terraform -chdir=./dev-cluster/base init
terraform -chdir=./dev-cluster/base destroy -auto-approve

terraform -chdir=./dev-cluster/istio init
terraform -chdir=./dev-cluster/istio destroy -auto-approve

terraform -chdir=./dev-cluster/cert-manager init
terraform -chdir=./dev-cluster/cert-manager destroy -auto-approve

# Environment configuration

terraform -chdir=./environments/local init
terraform -chdir=./environments/local destroy -auto-approve