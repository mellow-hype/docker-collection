
CTX ?= ../.
EXPLOITDEV_DOCKERFILE=exploitdev.Dockerfile

all: xdev-deb11 xdev-deb12 xdev-deb13 xdev-ubu20 xdev-ubu22 xdev-ubu24

# Claude Code + Vulnerability Research Environment
claude-vred: claude-vred.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

# Exploit Development Environments — single parameterized Dockerfile
xdev-ubu20:
	sudo docker build -t $@ \
	    --build-arg BASE_IMAGE=ubuntu20-base:latest \
	    --build-arg USERNAME=ubuntu \
	    --build-arg BUILD_PYTHON310=true \
	    -f $(EXPLOITDEV_DOCKERFILE) $(CTX)

xdev-ubu22:
	sudo docker build -t $@ \
	    --build-arg BASE_IMAGE=ubuntu22-base:latest \
	    --build-arg USERNAME=ubuntu \
	    -f $(EXPLOITDEV_DOCKERFILE) $(CTX)

xdev-ubu24:
	sudo docker build -t $@ \
	    --build-arg BASE_IMAGE=ubuntu24-base:latest \
	    --build-arg USERNAME=ubuntu \
	    --build-arg PEP668_WORKAROUND=true \
	    -f $(EXPLOITDEV_DOCKERFILE) $(CTX)

xdev-deb11:
	sudo docker build -t $@ \
	    --build-arg BASE_IMAGE=debian11-base:latest \
	    --build-arg USERNAME=user \
	    --build-arg BUILD_PYTHON310=true \
	    -f $(EXPLOITDEV_DOCKERFILE) $(CTX)

xdev-deb12:
	sudo docker build -t $@ \
	    --build-arg BASE_IMAGE=debian12-base:latest \
	    --build-arg USERNAME=user \
	    -f $(EXPLOITDEV_DOCKERFILE) $(CTX)

xdev-deb13:
	sudo docker build -t $@ \
	    --build-arg BASE_IMAGE=debian13-base:latest \
	    --build-arg USERNAME=user \
	    --build-arg PEP668_WORKAROUND=true \
	    -f $(EXPLOITDEV_DOCKERFILE) $(CTX)
