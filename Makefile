.PHONY: init-dev
init-dev:
	@cd "environments/dev" && terraform init -backend-config="../../backend.hcl" -upgrade

.PHONY: kubeconfig-dev
kubeconfig-dev:
	@aws eks update-kubeconfig --region ap-southeast-1 --name axorez-dev-cluster

.PHONY: plan-dev
plan-dev:
	@cd "environments/dev" && terraform plan -var-file="./terraform.tfvars"

.PHONY: apply-dev
apply-dev:
	@cd "environments/dev" && terraform apply -var-file="terraform.tfvars" -auto-approve