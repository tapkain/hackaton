# https://gist.github.com/mpneuried/0594963ad38e68917ef189b4e6a269db

# import config.
# You can change the default config with `make ENVS="config_special.env" build`
ENVS ?= config.env
include $(ENVS)
export $(shell sed 's/=.*//' $(ENVS))

VOLUMES ?= -v $(LOGS_VOLUME):$(LOGS_FOLDER) -v $(UPLOAD_VOLUME):$(UPLOAD_FOLDER)
PORTS ?= -p=$(WEB_PORT):$(WEB_PORT)

# DOCKER TASKS
# Build the container
build: ## Build the container
	docker build -t $(APP_NAME) .

build-nc: ## Build the container without caching
	docker build --no-cache -t $(APP_NAME) .

run: ## Run container on port configured in `config.env`
	docker run -i -t --rm --network="host" --env-file=$(ENVS) $(PORTS) --name="$(APP_NAME)" $(APP_NAME)


up: build run ## Run container on port configured in `config.env` (Alias to run)

stop: ## Stop and remove a running container
	docker stop $(APP_NAME); docker rm $(APP_NAME)

release: build-nc publish ## Make a release by building and publishing the `{version}` ans `latest` tagged containers to ECR
