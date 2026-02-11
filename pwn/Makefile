
CTX ?= ../.

all: xdev-deb11 xdev-deb12 xdev-deb13 xdev-ubu20 xdev-ubu22 xdev-ubu24

# Claude Code + Vulnerability Research Environment
claude-vred: claude-vred.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

# Exploit Development Environments
xdev-deb11: debian11-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

xdev-deb12: debian12-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

xdev-deb13: debian13-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

xdev-ubu20: ubuntu20-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

xdev-ubu22: ubuntu22-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

xdev-ubu24: ubuntu24-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

