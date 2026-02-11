
CONTEXT ?= $(PWD)

.PHONY: all bases exploit-dev claude-vred cross-arch aarch64-tools \
        tools claude-docker ghidra-headless static-analysis kaitai jammy-cql \
        kbuilders kbuilders-cross glibc-toolchains llvm-builder \
        lede-builder list clean

# ── Aggregate targets ────────────────────────────────────────────────────────

all: bases exploit-dev cross-arch tools

# ── Base images ──────────────────────────────────────────────────────────────

bases:
	make -C base-templates/ all

# ── Exploit development ──────────────────────────────────────────────────────

exploit-dev: bases
	make -C pwn/ all

claude-vred: claude-docker
	make -C pwn/ claude-vred

# ── Cross-architecture toolchains ────────────────────────────────────────────

cross-arch: bases aarch64-tools

aarch64-tools: bases
	sudo docker build -t aarch64-tools \
		-f cross-arch/aarch64-tools.Dockerfile .

# ── Tools ────────────────────────────────────────────────────────────────────

tools: claude-docker ghidra-headless static-analysis

claude-docker:
	make -C tools/claude-docker build

ghidra-headless:
	sudo docker build -t ghidra-headless \
		-f tools/ghidraHeadless/Dockerfile tools/ghidraHeadless/

static-analysis:
	sudo docker build -t static-analysis \
		-f tools/static-analysis/Dockerfile tools/static-analysis/

kaitai:
	sudo docker build -t kaitai \
		-f tools/kaitai.Dockerfile tools/

jammy-cql:
	sudo docker build -t jammy-cql \
		-f tools/jammy-cql.Dockerfile tools/

# ── Kernel builders ──────────────────────────────────────────────────────────

kbuilders:
	make -C builders/kbuilders all

kbuilders-cross:
	make -C builders/kbuilders cross

# ── Glibc toolchain builders ────────────────────────────────────────────────

glibc-toolchains:
	make -C builders/glibc-toolchains all

# ── LLVM builder ─────────────────────────────────────────────────────────────

llvm-builder:
	sudo docker build -t llvm-builder \
		-f builders/llvm-builder.Dockerfile builders/

# ── Misc ─────────────────────────────────────────────────────────────────────

lede-builder:
	sudo docker build -t jammy-lede-builder \
		-f misc/jammy-lede-builder.Dockerfile misc/

# ── Utility targets ──────────────────────────────────────────────────────────

# All known image tags produced by this build system
IMAGE_TAGS := \
	ubuntu20-base ubuntu22-base ubuntu24-base \
	debian11-base debian12-base debian13-base \
	xdev-ubu20 xdev-ubu22 xdev-ubu24 \
	xdev-deb11 xdev-deb12 xdev-deb13 \
	claude-vred \
	aarch64-tools \
	claude-docker ghidra-headless static-analysis kaitai jammy-cql \
	ubuntu18-kbuild-base ubuntu20-kbuild-base ubuntu22-kbuild-base ubuntu24-kbuild-base \
	debian11-kbuild-base debian12-kbuild-base debian13-kbuild-base \
	ubuntu18-kbuild-generic ubuntu20-kbuild-generic ubuntu22-kbuild-generic ubuntu24-kbuild-generic \
	debian11-kbuild-generic debian12-kbuild-generic debian13-kbuild-generic \
	ubuntu18-kbuild-arm64 ubuntu20-kbuild-arm64 \
	ubuntu18-kbuild-armhf ubuntu20-kbuild-armhf \
	ubuntu20-toolchain-builder ubuntu24-toolchain-builder \
	llvm-builder jammy-lede-builder

list:
	@echo ""
	@echo "=== Aggregate ==="
	@echo "  all                  bases + exploit-dev + cross-arch + tools"
	@echo ""
	@echo "=== Base Images ==="
	@echo "  bases                All base-template images (Ubuntu + Debian)"
	@echo ""
	@echo "=== Exploit Development ==="
	@echo "  exploit-dev          All xdev-* exploit-dev images (depends on bases)"
	@echo "  claude-vred          Claude VRED image (depends on claude-docker)"
	@echo ""
	@echo "=== Cross-Architecture ==="
	@echo "  cross-arch           All cross-arch toolchains (depends on bases)"
	@echo "  aarch64-tools        AArch64 cross-compilation toolchain"
	@echo ""
	@echo "=== Tools ==="
	@echo "  tools                claude-docker + ghidra-headless + static-analysis"
	@echo "  claude-docker        Claude Code development container"
	@echo "  ghidra-headless      Ghidra headless analysis container"
	@echo "  static-analysis      Static analysis tools container"
	@echo "  kaitai               Kaitai Struct container"
	@echo "  jammy-cql            CodeQL container (Ubuntu Jammy)"
	@echo ""
	@echo "=== Kernel Builders ==="
	@echo "  kbuilders            All kernel builder images (base + generic + cross)"
	@echo "  kbuilders-cross      Cross-architecture kernel builders only"
	@echo ""
	@echo "=== Toolchain Builders ==="
	@echo "  glibc-toolchains     Glibc toolchain builder images (u20 + u24)"
	@echo "  llvm-builder         LLVM/Clang builder container"
	@echo ""
	@echo "=== Misc ==="
	@echo "  lede-builder         LEDE/OpenWrt builder container"
	@echo ""
	@echo "=== Utility ==="
	@echo "  list                 Show this target summary"
	@echo "  clean                Remove all known image tags"
	@echo ""

clean:
	@echo "Removing all known image tags..."
	-sudo docker rmi -f $(IMAGE_TAGS)
	@echo "Done."
