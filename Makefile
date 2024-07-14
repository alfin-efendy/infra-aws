.PHONY: init
init:
	@cd "environments/dev" && terraform init -backend-config="../../backend.hcl" -upgrade

.PHONY: kubeconfig-dev
kubeconfig-dev:
	@aws eks update-kubeconfig --region ap-southeast-1 --name axorez-dev-cluster