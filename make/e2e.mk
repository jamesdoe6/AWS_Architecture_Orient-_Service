DEPLOYMENT ?= demo-web
LABEL      ?= app=demo-web

.PHONY: e2e.pods e2e.delete-pod e2e.test e2e.scale-1 e2e.scale-3 e2e.watch

e2e.pods:
	@echo ">>> Etat des pods ($(LABEL)) :"
	@kubectl get pods -l $(LABEL) -o wide

e2e.delete-pod:
	@POD=$$(kubectl get pod -l $(LABEL) -o jsonpath='{.items[0].metadata.name}'); \
	echo ">>> Suppression du pod : $$POD"; \
	kubectl delete pod $$POD

e2e.test:
	@echo "========================================="
	@echo " TEST E2E - Zero-downtime avec replicas"
	@echo "========================================="
	@$(MAKE) --no-print-directory e2e.pods
	@$(MAKE) --no-print-directory e2e.delete-pod
	@sleep 3
	@$(MAKE) --no-print-directory e2e.pods

e2e.scale-1:
	@kubectl scale deployment $(DEPLOYMENT) --replicas=1
	@$(MAKE) --no-print-directory e2e.pods

e2e.scale-3:
	@kubectl scale deployment $(DEPLOYMENT) --replicas=3
	@$(MAKE) --no-print-directory e2e.pods

e2e.watch:
	@watch -n1 kubectl get pods -l $(LABEL)
