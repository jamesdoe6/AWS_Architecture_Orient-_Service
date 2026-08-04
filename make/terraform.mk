ENV ?= dev
TF_DIR := infra/envs/$(ENV)

.PHONY: tf.init
tf.init: ## Initialize Terraform in the specified environment directory
	@terraform -chdir=$(TF_DIR) init -input=false

.PHONY: tf.fmt
tf.fmt: ## Format Terraform configuration files in the specified environment directory
	@terraform -chdir=$(TF_DIR) fmt -diff -recursive

.PHONY: tf.fmt.check
tf.fmt.check: ## Check formatting of Terraform configuration files in the specified environment directory
	@terraform -chdir=$(TF_DIR) fmt --check -recursive

.PHONY: tf.fmt.ci
tf.fmt.ci: tf.fmt.check

.PHONY: infra-plan infra-apply infra-destroy
infra-plan:
	cd infra && terraform plan

infra-apply:
	cd infra && terraform apply -auto-approve

infra-destroy:
	cd infra && terraform destroy -auto-approve
