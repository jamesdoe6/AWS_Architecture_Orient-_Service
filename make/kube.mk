KUBE_DIR := kube

.PHONY: kube.context kube.check.context kube.apply kube.pods kube.delete

kube.context: ## Set the Kubernetes context to the specified cluster
	@kubectl config use-context minikube

kube.check.context: ## Display the current Kubernetes context
	@kubectl config current-context

kube.apply: guard-DEPLOYMENT_MANIFEST ## Apply the Kubernetes deployment manifest
	@kubectl apply -f $(KUBE_DIR)/$(DEPLOYMENT_MANIFEST)

kube.pods: ## List running pods
	@kubectl get pods

kube.delete: guard-DEPLOYMENT_MANIFEST ## Delete the Kubernetes deployment manifest
	@kubectl delete -f $(KUBE_DIR)/$(DEPLOYMENT_MANIFEST)

kube.tunnel: ## Create a tunnel to the Kubernetes cluster
	@kubectl port-forward svc/$(SERVICE_NAME) 8080:80

kube.start: ## Start the Kubernetes cluster
	@minikube start

kube.pfwd: ## Port forward to the Kubernetes service
	@kubectl port-forward svc/$(SERVICE_NAME) 8080:80
