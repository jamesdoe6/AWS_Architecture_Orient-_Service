# project.mk — Orchestration globale du projet (fil rouge Jour 5)
# Version Minikube : rapide, gratuite, sans dependance AWS EKS
# Enchaine : cluster local -> platform (add-ons/policies) -> apps -> verification

.PHONY: all up platform apps verify down

## Pipeline complete du projet, en une seule commande
all: up platform apps verify

## Couche 1 : demarrage du cluster local + contexte
up:
	minikube start --driver=docker
	kubectl config use-context minikube

## Couche 2 : add-ons, autoscaler, policies de gouvernance
platform:
	kubectl apply -f platform/ --recursive || true
	kubectl apply -f policies/ --recursive || true

## Couche 3 : applications
apps:
	kubectl apply -f apps/ --recursive

## Preuves pour la soutenance
verify:
	@echo ">>> Nodes, Pods, HPA :"
	kubectl get nodes,pods,hpa -A

## Demontage propre (a lancer apres la soutenance)
down:
	kubectl delete -f apps/ --recursive --ignore-not-found=true
	kubectl delete -f platform/ --recursive --ignore-not-found=true
	kubectl delete -f policies/ --recursive --ignore-not-found=true
	@echo ">>> Verification des ressources restantes :"
	kubectl get all -A --no-headers | grep -v kube-system || echo "Namespace default propre."
	minikube stop

## Nettoyage total (reset complet, avant remise a zero)
down-full: down
	minikube delete --all --purge

clean:
	@echo "Nettoyage des ressources locales (build artifacts, etc.)"
