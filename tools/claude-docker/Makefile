
IMAGE_TAG := claude-docker
CONTEXT ?= .

all: build install

build: Dockerfile
	sudo docker build -t $(IMAGE_TAG) -f Dockerfile $(CONTEXT)

install: clauded.sh
	mkdir -p ~/bin && ln -s $(PWD)/clauded.sh ~/bin/clauded.sh

