.PHONY: docker.img.create
docker.img.create: guard-IMAGE_NAME ## Build the docker image
	docker build -t $(IMAGE_NAME) $(DOCKER_DIR)/.

.PHONY: docker.img.list
docker.img.list: ## List docker images
	@docker image ls

.PHONY: docker.img.get
docker.img.get: guard-IMAGE_NAME ## Get the docker image
	docker image ls | grep -i $(IMAGE_NAME)

.PHONY: docker.img.remove
docker.img.remove: guard-IMAGE_NAME ## Remove the docker image
	docker image rm $(IMAGE_NAME)

.PHONY: dockerhub.login
dockerhub.login: ## Login to DockerHub
	docker login -u $(DOCKERHUB_USER)

.PHONY: docker.img.tag
docker.img.tag: guard-IMAGE_NAME ## Tag the docker image for DockerHub
	docker tag $(IMAGE_NAME) $(DOCKERHUB_IMAGE):$(TAG)

.PHONY: docker.img.push
docker.img.push: guard-IMAGE_NAME ## Push the docker image to DockerHub
	docker push $(DOCKERHUB_IMAGE):$(TAG)

.PHONY: dockerhub.push
dockerhub.push: dockerhub.login docker.img.tag docker.img.push ## Full DockerHub
