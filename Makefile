IMAGE_NAME      := claude-cli-sandbox
CONTAINER_NAME  := claude-cli-sandbox
TIMESTAMP       := $(shell date +%Y%m%d-%H%M%S)
CODE_DIR        := ~/Workplace
CONFIG_DIR      := ~/.claude-config-sandbox

.PHONY: build create clean

build:
	docker build \
		-f claude-cli-sandbox.dockerfile \
		-t $(IMAGE_NAME):latest \
		-t $(IMAGE_NAME):$(TIMESTAMP) \
		.

create:
	docker create -it \
		--name $(CONTAINER_NAME) \
		--hostname $(CONTAINER_NAME) \
		-v $(CODE_DIR):/home/dev/code \
		-v ${CONFIG_DIR}:/home/dev/.claude-config \
		$(IMAGE_NAME):latest

clean:
	docker rm $(CONTAINER_NAME)
