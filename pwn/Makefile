
CTX ?= ../.

all: exploit-deb11 exploit-deb12 exploit-deb13 exploit-ubu20 exploit-ubu22 exploit-ubu24

# Exploit Development Environments
exploit-deb11: debian11-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

exploit-deb12: debian12-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

exploit-deb13: debian13-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

exploit-ubu20: ubuntu20-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

exploit-ubu22: ubuntu22-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

exploit-ubu24: ubuntu24-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

