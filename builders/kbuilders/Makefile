
DOCKER_BASE_DIR:=./base
BASE_DOCKERFILE=$(DOCKER_BASE_DIR)/kbuilder-base.Dockerfile
BASE_IMAGE_POSTFIX:=kbuild-base
BASES := ubuntu18_base ubuntu20_base ubuntu22_base ubuntu24_base debian11_base debian12_base debian13_base

all: $(BASES) generic_builders cross_builders
cross: cross_builders

# Base images — single Dockerfile, parameterized via --build-arg
ubuntu18_base:
	sudo docker build -t ubuntu18-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=ubuntu:18.04 \
	    --build-arg EXTRA_PACKAGES="python python-lzo python2.7-dev" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

ubuntu20_base:
	sudo docker build -t ubuntu20-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=ubuntu:20.04 \
	    --build-arg EXTRA_PACKAGES="curl python python2.7-dev python3-lzo swig unrar xsltproc" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

ubuntu22_base:
	sudo docker build -t ubuntu22-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=ubuntu:22.04 \
	    --build-arg EXTRA_PACKAGES="curl python2.7-dev python3-lzo swig unrar xsltproc" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

ubuntu24_base:
	sudo docker build -t ubuntu24-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=ubuntu:24.04 \
	    --build-arg EXTRA_PACKAGES="curl python3-lzo swig unrar xsltproc" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

debian11_base:
	sudo docker build -t debian11-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=debian:bullseye \
	    --build-arg EXTRA_PACKAGES="curl python2.7-dev python3-lzo swig xsltproc" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

debian12_base:
	sudo docker build -t debian12-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=debian:bookworm \
	    --build-arg EXTRA_PACKAGES="curl python3-lzo swig xsltproc" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

debian13_base:
	sudo docker build -t debian13-$(BASE_IMAGE_POSTFIX) \
	    --build-arg BASE_IMAGE=debian:trixie \
	    --build-arg EXTRA_PACKAGES="curl python3-lzo swig xsltproc" \
	    -f $(BASE_DOCKERFILE) $(DOCKER_BASE_DIR)

CROSS_DOCKERFILE=./kbuilder-cross.Dockerfile

# Cross-architecture builders — single parameterized Dockerfile
ubuntu18_arm64: ubuntu18_base
	sudo docker build -t ubuntu18-kbuild-arm64 \
	    --build-arg BASE_IMAGE=ubuntu18-kbuild-base:latest \
	    --build-arg CROSS_PACKAGES="gcc-aarch64-linux-gnu libc6-dev-arm64-cross" \
	    -f $(CROSS_DOCKERFILE) .

ubuntu20_arm64: ubuntu20_base
	sudo docker build -t ubuntu20-kbuild-arm64 \
	    --build-arg BASE_IMAGE=ubuntu20-kbuild-base:latest \
	    --build-arg CROSS_PACKAGES="gcc-aarch64-linux-gnu libc6-dev-arm64-cross" \
	    -f $(CROSS_DOCKERFILE) .

arm64_builders: ubuntu18_arm64 ubuntu20_arm64

ubuntu18_armhf: ubuntu18_base
	sudo docker build -t ubuntu18-kbuild-armhf \
	    --build-arg BASE_IMAGE=ubuntu18-kbuild-base:latest \
	    --build-arg CROSS_PACKAGES="gcc-arm-linux-gnueabihf" \
	    -f $(CROSS_DOCKERFILE) .

ubuntu20_armhf: ubuntu20_base
	sudo docker build -t ubuntu20-kbuild-armhf \
	    --build-arg BASE_IMAGE=ubuntu20-kbuild-base:latest \
	    --build-arg CROSS_PACKAGES="gcc-arm-linux-gnueabihf libc6-dev-armhf-cross" \
	    -f $(CROSS_DOCKERFILE) .

arm_builders: ubuntu18_armhf ubuntu20_armhf

cross_builders: arm64_builders arm_builders

# Generic builders (docker tag aliases — base images are functionally complete)
ubuntu18_generic: ubuntu18_base
	sudo docker tag ubuntu18-kbuild-base ubuntu18-kbuild-generic

ubuntu20_generic: ubuntu20_base
	sudo docker tag ubuntu20-kbuild-base ubuntu20-kbuild-generic

ubuntu22_generic: ubuntu22_base
	sudo docker tag ubuntu22-kbuild-base ubuntu22-kbuild-generic

ubuntu24_generic: ubuntu24_base
	sudo docker tag ubuntu24-kbuild-base ubuntu24-kbuild-generic

ubuntu_builders_generic: ubuntu18_generic ubuntu20_generic ubuntu22_generic ubuntu24_generic

debian11_generic: debian11_base
	sudo docker tag debian11-kbuild-base debian11-kbuild-generic

debian12_generic: debian12_base
	sudo docker tag debian12-kbuild-base debian12-kbuild-generic

debian13_generic: debian13_base
	sudo docker tag debian13-kbuild-base debian13-kbuild-generic

debian_builders_generic: debian11_generic debian12_generic debian13_generic

generic_builders: debian_builders_generic ubuntu_builders_generic
	$(info All done building generic kernel builder containers!)

# LEDE/OpenWrt convenience aliases (not included in 'all')
lede: ubuntu20_base
	sudo docker tag ubuntu20-kbuild-base ubuntu20-kbuild-lede

lede_arm64: ubuntu20_arm64
	sudo docker tag ubuntu20-kbuild-arm64 ubuntu20-kbuild-lede-arm64
