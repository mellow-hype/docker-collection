
CTX ?= ../.

all: exploit-deb11 exploit-deb12

# Exploit Development Environments
exploit-deb11: debian11-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

exploit-deb12: debian12-exploitdev.Dockerfile
	sudo docker build -t $@ -f $< $(CTX)

