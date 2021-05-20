.DEFAULT_GOAL := help
.PHONY: help

help: ## This help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

build: ## Build debian image (default)
	@docker-compose build

alpine: ## Build alpine minimal image
	@docker-compose -f alpine/docker-compose.yml build

trivy: ## Docker image vulnerability scan
	@docker run --rm -v /var/run/docker.sock:/var/run/docker.sock ghcr.io/aquasecurity/trivy:0.16.0 $2