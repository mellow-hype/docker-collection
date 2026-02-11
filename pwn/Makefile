
CTX ?= ../.
EXPLOITDEV_DOCKERFILE=exploitdev.Dockerfile

LOG_DIR := build-logs
VERBOSE ?= 0

XDEV_TARGETS := xdev-deb11 xdev-deb12 xdev-deb13 xdev-ubu20 xdev-ubu22 xdev-ubu24

.PHONY: all claude-vred $(XDEV_TARGETS) clean-logs

all: $(XDEV_TARGETS)

# docker_build(name, dockerfile, build-args)
#   Normal mode: captures output to LOG_DIR/name.log, prints status summary.
#   VERBOSE=1: streams build output directly to stdout for debugging.
define docker_build
	@mkdir -p $(LOG_DIR) && \
	if [ "$(VERBOSE)" = "1" ]; then \
		echo "Building $(1)..."; \
		sudo docker build -t $(1) $(3) -f $(2) $(CTX); \
	else \
		echo "Building $(1)..."; \
		if sudo docker build -t $(1) $(3) -f $(2) $(CTX) > $(LOG_DIR)/$(1).log 2>&1; then \
			echo "[OK]    $(1)"; \
		else \
			echo "[FAIL]  $(1) -- see $(LOG_DIR)/$(1).log"; \
			echo "--- Last 30 lines ---"; \
			tail -30 $(LOG_DIR)/$(1).log; \
			exit 1; \
		fi; \
	fi
endef

# Claude Code + Vulnerability Research Environment
claude-vred:
	$(call docker_build,claude-vred,claude-vred.Dockerfile,)

# Exploit Development Environments — single parameterized Dockerfile
xdev-ubu20:
	$(call docker_build,xdev-ubu20,$(EXPLOITDEV_DOCKERFILE),--build-arg BASE_IMAGE=ubuntu20-base:latest --build-arg USERNAME=ubuntu --build-arg BUILD_PYTHON310=true)

xdev-ubu22:
	$(call docker_build,xdev-ubu22,$(EXPLOITDEV_DOCKERFILE),--build-arg BASE_IMAGE=ubuntu22-base:latest --build-arg USERNAME=ubuntu)

xdev-ubu24:
	$(call docker_build,xdev-ubu24,$(EXPLOITDEV_DOCKERFILE),--build-arg BASE_IMAGE=ubuntu24-base:latest --build-arg USERNAME=ubuntu --build-arg PEP668_WORKAROUND=true)

xdev-deb11:
	$(call docker_build,xdev-deb11,$(EXPLOITDEV_DOCKERFILE),--build-arg BASE_IMAGE=debian11-base:latest --build-arg USERNAME=user --build-arg BUILD_PYTHON310=true)

xdev-deb12:
	$(call docker_build,xdev-deb12,$(EXPLOITDEV_DOCKERFILE),--build-arg BASE_IMAGE=debian12-base:latest --build-arg USERNAME=user)

xdev-deb13:
	$(call docker_build,xdev-deb13,$(EXPLOITDEV_DOCKERFILE),--build-arg BASE_IMAGE=debian13-base:latest --build-arg USERNAME=user --build-arg PEP668_WORKAROUND=true)

clean-logs:
	rm -rf $(LOG_DIR)
