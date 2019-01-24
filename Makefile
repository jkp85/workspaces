.PHONY: help build build-all build-test-all dev dev-env push-dockerhub test

# Docker image name and tag. ACCOUNT is used here instead
# of OWNER since we may push to another registry in the future.
OWNER?=$(OWNER)
IMAGE?=$(DOCKER_IMAGE)
NAMESPACE:=$(OWNER)/$(DOCKER_IMAGE)
TAG?=latest
# Shell that make should use
SHELL:=bash

ALL_STACKS:=datascience-notebook

ALL_IMAGES:=$(ALL_STACKS)

help:
# http://marmelab.com/blog/2016/02/29/auto-documented-makefile.html
	@echo "==========================="
	@echo "IllumiDesk workspace images"
	@echo "==========================="
	@echo ""
	@echo "Replace '%' with a stack directory name. The build command will add "
	@echo "the owner name and a tag to the image name (e.g. 'make build/datascience-notebook'"
	@echo "will create make 'acmeinc/datascience-notebook:latest')."
	@echo
	@grep -E '^[a-zA-Z0-9_%/-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build/%: DARGS?=
build/%: ## Build and tag a stack
	docker build $(DARGS) --rm --force-rm -t $(OWNER)/$(notdir $@):$(TAG) ./$(notdir $@)

build-all: $(foreach I,$(ALL_IMAGES), build/$(I) ) ## Build all stacks

dev/%: ARGS?=
dev/%: DARGS?=
dev/%: PORT?=8888
dev/%: ## Make a container from a tagged image image
	docker run -it --rm -p $(PORT):8888 $(DARGS) $(OWNER)/$(notdir $@) $(ARGS)

dev-env: ## Install libraries required to run containers and tests
	pip install -r requirements-dev.txt

push/%: ## Build and tag a stack
	docker push $(OWNER)/$(notdir $@):$(TAG)

push-all: $(foreach I,$(ALL_IMAGES), push/$(I) ) ## Push all stacks