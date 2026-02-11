
DOCKER_DIR := .
BUILD_CONTEXT := ..
BASE_DOCKERFILE = $(DOCKER_DIR)/base.Dockerfile
IMAGE_POSTFIX := base
UBUNTU := ubuntu20 ubuntu22 ubuntu24
DEBIAN := debian11 debian12 debian13

LOG_DIR := build-logs
VERBOSE ?= 0

.PHONY: all ubuntu debian $(UBUNTU) $(DEBIAN) clean-logs

all: ubuntu debian

# Ubuntu base images
ubuntu: $(UBUNTU)

# Debian base images
debian: $(DEBIAN)

# docker_build(name, build-args)
#   Normal mode: captures output to LOG_DIR/name.log, prints status summary.
#   VERBOSE=1: streams build output directly to stdout for debugging.
define docker_build
	@mkdir -p $(LOG_DIR) && \
	if [ "$(VERBOSE)" = "1" ]; then \
		echo "Building $(1)..."; \
		sudo docker build -t $(1)-$(IMAGE_POSTFIX) $(2) -f $(BASE_DOCKERFILE) $(BUILD_CONTEXT); \
	else \
		echo "Building $(1)..."; \
		if sudo docker build -t $(1)-$(IMAGE_POSTFIX) $(2) -f $(BASE_DOCKERFILE) $(BUILD_CONTEXT) > $(LOG_DIR)/$(1).log 2>&1; then \
			echo "[OK]    $(1)"; \
		else \
			echo "[FAIL]  $(1) -- see $(LOG_DIR)/$(1).log"; \
			echo "--- Last 30 lines ---"; \
			tail -30 $(LOG_DIR)/$(1).log; \
			exit 1; \
		fi; \
	fi
endef

ubuntu20:
	$(call docker_build,ubuntu20,--build-arg BASE_IMAGE=ubuntu:20.04 --build-arg USERNAME=ubuntu --build-arg CREATE_USER=false)

ubuntu22:
	$(call docker_build,ubuntu22,--build-arg BASE_IMAGE=ubuntu:22.04 --build-arg USERNAME=ubuntu --build-arg CREATE_USER=false)

ubuntu24:
	$(call docker_build,ubuntu24,--build-arg BASE_IMAGE=ubuntu:24.04 --build-arg USERNAME=ubuntu --build-arg CREATE_USER=false)

debian11:
	$(call docker_build,debian11,--build-arg BASE_IMAGE=debian:bullseye --build-arg USERNAME=user --build-arg CREATE_USER=true)

debian12:
	$(call docker_build,debian12,--build-arg BASE_IMAGE=debian:bookworm --build-arg USERNAME=user --build-arg CREATE_USER=true)

debian13:
	$(call docker_build,debian13,--build-arg BASE_IMAGE=debian:trixie --build-arg USERNAME=user --build-arg CREATE_USER=true)

clean-logs:
	rm -rf $(LOG_DIR)
