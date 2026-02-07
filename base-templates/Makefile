
UBUNTU20_DOCKERFILE=$(DOCKER_DIR)/ubuntu-20.04.Dockerfile
UBUNTU22_DOCKERFILE=$(DOCKER_DIR)/ubuntu-22.04.Dockerfile
UBUNTU24_DOCKERFILE=$(DOCKER_DIR)/ubuntu-24.04.Dockerfile
DEBIAN11_DOCKERFILE=$(DOCKER_DIR)/debian-11.Dockerfile
DEBIAN12_DOCKERFILE=$(DOCKER_DIR)/debian-12.Dockerfile
DEBIAN13_DOCKERFILE=$(DOCKER_DIR)/debian-13.Dockerfile
DOCKER_DIR:=.
IMAGE_POSTFIX:=base
UBUNTU := ubuntu20 ubuntu22 ubuntu24
DEBIAN := debian11 debian12 debian13

all: ubuntu debian

# Ubuntu base images
ubuntu: $(UBUNTU)

ubuntu20:
	sudo docker build -t ubuntu20-$(IMAGE_POSTFIX) -f $(UBUNTU20_DOCKERFILE) $(DOCKER_DIR)

ubuntu22:
	sudo docker build -t ubuntu22-$(IMAGE_POSTFIX) -f $(UBUNTU22_DOCKERFILE) $(DOCKER_DIR)

ubuntu24:
	sudo docker build -t ubuntu24-$(IMAGE_POSTFIX) -f $(UBUNTU24_DOCKERFILE) $(DOCKER_DIR)

# Debian base images
debian: $(DEBIAN)

debian11:
	sudo docker build -t debian11-$(IMAGE_POSTFIX) -f $(DEBIAN11_DOCKERFILE) $(DOCKER_DIR)

debian12:
	sudo docker build -t debian12-$(IMAGE_POSTFIX) -f $(DEBIAN12_DOCKERFILE) $(DOCKER_DIR)

debian13:
	sudo docker build -t debian13-$(IMAGE_POSTFIX) -f $(DEBIAN13_DOCKERFILE) $(DOCKER_DIR)
