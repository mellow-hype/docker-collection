
IMAGE_TAG := claude-docker
CONTEXT ?= .

build: Dockerfile
	sudo docker build -t $(IMAGE_TAG) -f Dockerfile $(CONTEXT)


