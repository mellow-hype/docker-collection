IMAGE_TAG := claude-docker
CONTEXT ?= .
DOCKERFILE := Dockerfile

# Build variables (override on command line, e.g. make build BASE_IMAGE=debian:13)
BASE_IMAGE ?= ubuntu:24.04
DOCKUSER ?= ubuntu
EXTRA_PACKAGES ?=

BUILD_ARGS := --build-arg BASE_IMAGE=$(BASE_IMAGE) \
              --build-arg USERNAME=$(DOCKUSER) \
              --build-arg EXTRA_PACKAGES="$(EXTRA_PACKAGES)"

all: build install

build: $(DOCKERFILE)
	sudo docker build -t $(IMAGE_TAG) $(BUILD_ARGS) -f $(DOCKERFILE) $(CONTEXT)

# Pattern rule: make build-<label> → tags image as claude-docker-<label>
# Example: make build-deb13 BASE_IMAGE=debian:13 DOCKUSER=user
build-%: $(DOCKERFILE)
	sudo docker build -t $(IMAGE_TAG)-$* $(BUILD_ARGS) -f $(DOCKERFILE) $(CONTEXT)

install: clauded.sh
	mkdir -p ~/bin && ln -s $(PWD)/clauded.sh ~/bin/clauded.sh

.PHONY: all build install
