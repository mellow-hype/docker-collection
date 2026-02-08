
DOCKER_DIR := .
IMAGE_POSTFIX := toolchain-builder

all: glibc-builder-u20 glibc-builder-u24

glibc-builder-u20:
	sudo docker build -t ubuntu20-$(IMAGE_POSTFIX) \
		-f $(DOCKER_DIR)/ubuntu_20.04-toolchain-builder.Dockerfile $(DOCKER_DIR)

glibc-builder-u24:
	sudo docker build -t ubuntu24-$(IMAGE_POSTFIX) \
		-f $(DOCKER_DIR)/ubuntu_24.04-toolchain-builder.Dockerfile $(DOCKER_DIR)
