.PHONY: ansible-run
ansible-run: ## Exécute le playbook Ansible
	ansible-playbook $(ANSIBLE_DIR)/playbook.yml
