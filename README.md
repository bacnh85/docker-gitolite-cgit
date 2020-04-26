# gitolite-cgit based on alpine image

## What is this image?

[`bacnh85/gitolite-cgit`](https://hub.docker.com/r/bacnh85/gitolite-cgit) is a Docker image with `cgit` and `gitolite` running on top of `alpine` base image. Dockerfile is available at [Github repo](https://github.com/bacnh85/docker-gitolite-cgit).

![cgit](img/cgit.png)

## Usage

1. Pull the image

```
docker pull bacnh85/gitolite-cgit
```

2. Run the image with provided environment:

```
docker run -e SSH_KEY="$(cat ~/.ssh/id_rsa.pub)" -e SSH_KEY_NAME="$(whoami)" -p 22:22 -v repo:/var/lib/git/ bacnh85/gitolite-cgit
```

## Test result

1) Gitolite: you can start to clone the gitolite-admin to your workstation:

```
git clone git@<server IP>:gitolite-admin
```

2) Cgit webpage: `http://<server_ip>/cgit`

## Docker-compose

1. Pull the image:

```
docker pull bacnh85/gitolite-cgit
```

2. Create environment file

In this repo, I create `gitolite` admin with the host public key and username. In case, you are running this on server, you need to enter SSH_KEY and SSH_KEY_NAME into `config.env`:

```
#
# Gitolite options
#
SSH_KEY=<your public key content>
SSH_KEY_NAME=<your gitolite name>
```

For convience, I create a script for user who use the public key and name from the host running Docker:

```
# change ssh_key, ssh_key_name to reflect your current setup
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
SSH_KEY_NAME=$(whoami)

sed -i.bak \
    -e "s#SSH_KEY=.*#SSH_KEY=${SSH_KEY}#g" \
    -e "s#SSH_KEY_NAME=.*#SSH_KEY_NAME=${SSH_KEY_NAME}#g" \
    "$(dirname "$0")/config.env"
```

3. Create `docker-compose.yml`:

```
version: '3'

services:
  app:
    image: bacnh85/gitolite-cgit
    container_name: gitolite-cgit
    env_file: config.env
    volumes: 
      - git:/var/lib/git/
    ports:
      - 22:22
    tty: true
volumes: 
  git:
```
Then power-on your container:
```
docker-compose up -d
```

## Environment

- `SSH_KEY`: Public key of gitolite admin
- `SSH_KEY_NAME`: Name of gitolite admin

## Build docker image

```
git clone https://github.com/bacnh85/docker-gitolite-cgit.git
cd docker-gitolite-cgit
docker build gitolite-cgit -t bacnh85/gitolite-cgit
```

