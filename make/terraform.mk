ENV ?= dev
TF_DIR := infra/envs/$(ENV)

.PHONY: tf.init
tf.init: ## Initialize Terraform in the specified environment directory
	@terraform -chdir=$(TF_DIR) init -input=false

.PHONY: tf.fmt
tf.fmt: ## Format Terraform configuration files in the specified environment directory
	@terraform -chdir=$(TF_FMT_DIR) fmt -diff -recursive

.PHONY: tf.fmt.check
tf.fmt.check: ## Check formatting of Terraform configuration files in the specified environment directory
	@terraform -chdir=$(TF_FMT_DIR) fmt --check -recursive

.PHONY: tf.fmt.ci
tf.fmt.ci: tf.fmt.check

.PHONY: infra-plan infra-apply infra-destroy
infra-plan:
	cd infra && terraform plan

infra-apply:
	cd infra && terraform apply -auto-approve

infra-destroy:
	cd infra && terraform destroy -auto-approve

.PHONY: tf.lint
tf.lint: tf.fmt ## Lint Terraform configuration files in the specified environment directory
	@tflint --chdir=$(TF_FMT_DIR) --recursive --config=$(path.cwd) --fix

.PHONY: tf.lint.ci
tf.lint.ci: ## Lint Terraform configuration files in the specified environment directory for CI
	@tflint --chdir=$(TF_FMT_DIR) --recursive --config=$(path.cwd)

.PHONY: tf.trivy
tf.trivy: ## Scan Terraform configuration files for vulnerabilities using Trivy
	@trivy config --exit-code 1 --severity HIGH,CRITICAL $(TF_DIR)

.PHONY: tf.normalize
tf.normalize: tf.fmt tf.lint

.PHONY:
tf.check.ci: tf.fmt.ci tf.lint.ci tf.trivy
