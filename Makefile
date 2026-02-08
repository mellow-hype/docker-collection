
CONTEXT ?= $(PWD)

# base images
bases:
	make -C base-templates/ all

# Exploit Development Environments
exploit-dev: bases
	make -C pwn/ all

