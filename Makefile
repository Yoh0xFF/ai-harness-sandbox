IMAGE_NAME      := claude-cli-sandbox
CONTAINER_NAME  := claude-cli-sandbox
TIMESTAMP       := $(shell date +%Y%m%d-%H%M%S)

.PHONY: build run start stop clean

build:
	docker build \
		-f claude-cli-sandbox.dockerfile \
		-t $(IMAGE_NAME):latest \
		-t $(IMAGE_NAME):$(TIMESTAMP) \
		.

run:
	docker run -it \
		--name $(CONTAINER_NAME) \
		-v $(CODE_DIR):/home/dev/code \
		-v ~/.claude-config-sandbox:/home/dev/.claude-config \
		$(IMAGE_NAME):latest

start:
	docker start -ai $(CONTAINER_NAME)

stop:
	docker stop $(CONTAINER_NAME)

clean:
	docker rm $(CONTAINER_NAME)
