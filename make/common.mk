INFO_COLOR := \033[36;1m
ERROR_COLOR := \033[31;1m
SUCCESS_COLOR := \033[32;1m
WARNING_COLOR := \033[33;1m
NO_COLOR := \033[0m

#==========================================
ANSIBLE_DIR := ansible
DOCKER_DIR := Docker
DOCKERHUB_USER := jamesdoe6
DOCKERHUB_IMAGE := $(DOCKERHUB_USER)/web-bc
IMAGE_NAME := web-bc:1.0
TAG := 1.0
#==========================================
.DEFAUTT_GOAL := help
.PHONY: help check-tools.

guard-%:
	@[ -n "$($*)" ] || (echo -e "$(ERROR_COLOR)Error: $* is not defined.$(NO_COLOR)"; exit 1;)

help: ## show this help
	echo -e "\n$(INFO_COLOR)Usage:$(NO_COLOR) make <target>\n"
	echo -e "$(INFO_COLOR)=================== TARGETS ===================$(NO_COLOR)"
	grep -hE "^[a-zA-Z._-]+:.*## .*$$" $(MAKEFILE_LIST) | sort |\
		awk 'BEGIN {FS = ":.*## "}; {printf "$(SUCCESS_COLOR)%-30s$(NO_COLOR) %s\n", $$1, $$2}'
	echo -e "$(INFO_COLOR)===============================================$(NO_COLOR)"
