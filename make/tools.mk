.ONESHELL:
SHELL := /bin/bash
.SHELLFLAGS := -euo pipefail -c
#==============================================
.SILENT: help
.SILENT: check.tools
.PHONY: check.tools

check.tools: ## Check if required tools are installed
	for software in terraform eksctl kubectl docker aws pre-commit git minikube tflint trivy kyverno; do
		command -v "$$software" >/dev/null 2>&1 \
			&& echo -e "$(SUCCESS_COLOR)$$software is installed.$(NO_COLOR)" \
			|| echo -e "$(ERROR_COLOR)$$software is not installed.$(NO_COLOR)"
	done
