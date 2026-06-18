NAME       := claude-cli-sandbox
TIMESTAMP  := $(shell date +%Y%m%d-%H%M%S)
CODE_DIR   := ~/Workplace
CONFIG_DIR := ~/.claude-config-sandbox

.PHONY: build create clean

build:
	docker build \
		-f claude-cli-sandbox.dockerfile \
		-t $(NAME):latest \
		-t $(NAME):$(TIMESTAMP) \
		.

create:
	docker create -it \
		--name $(NAME) \
		--hostname $(NAME) \
		-v $(CODE_DIR):/home/dev/code \
		-v ${CONFIG_DIR}:/home/dev/.claude-config \
		$(NAME):latest

clean:
	docker rm $(NAME)
