
DOCKER_DIR:=.
BUILD_CONTEXT:=..
BASE_DOCKERFILE=$(DOCKER_DIR)/base.Dockerfile
IMAGE_POSTFIX:=base
UBUNTU := ubuntu20 ubuntu22 ubuntu24
DEBIAN := debian11 debian12 debian13

all: ubuntu debian

# Ubuntu base images
ubuntu: $(UBUNTU)

ubuntu20:
	sudo docker build -t ubuntu20-$(IMAGE_POSTFIX) \
		--build-arg BASE_IMAGE=ubuntu:20.04 \
		--build-arg USERNAME=ubuntu \
		--build-arg CREATE_USER=false \
		-f $(BASE_DOCKERFILE) $(BUILD_CONTEXT)

ubuntu22:
	sudo docker build -t ubuntu22-$(IMAGE_POSTFIX) \
		--build-arg BASE_IMAGE=ubuntu:22.04 \
		--build-arg USERNAME=ubuntu \
		--build-arg CREATE_USER=false \
		-f $(BASE_DOCKERFILE) $(BUILD_CONTEXT)

ubuntu24:
	sudo docker build -t ubuntu24-$(IMAGE_POSTFIX) \
		--build-arg BASE_IMAGE=ubuntu:24.04 \
		--build-arg USERNAME=ubuntu \
		--build-arg CREATE_USER=false \
		-f $(BASE_DOCKERFILE) $(BUILD_CONTEXT)

# Debian base images
debian: $(DEBIAN)

debian11:
	sudo docker build -t debian11-$(IMAGE_POSTFIX) \
		--build-arg BASE_IMAGE=debian:bullseye \
		--build-arg USERNAME=user \
		--build-arg CREATE_USER=true \
		-f $(BASE_DOCKERFILE) $(BUILD_CONTEXT)

debian12:
	sudo docker build -t debian12-$(IMAGE_POSTFIX) \
		--build-arg BASE_IMAGE=debian:bookworm \
		--build-arg USERNAME=user \
		--build-arg CREATE_USER=true \
		-f $(BASE_DOCKERFILE) $(BUILD_CONTEXT)

debian13:
	sudo docker build -t debian13-$(IMAGE_POSTFIX) \
		--build-arg BASE_IMAGE=debian:trixie \
		--build-arg USERNAME=user \
		--build-arg CREATE_USER=true \
		-f $(BASE_DOCKERFILE) $(BUILD_CONTEXT)
