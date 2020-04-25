# gitolite-cgit based on alpine image

## What is this image?

`bacnh85/gitolite-cgit` is a Docker image with `cgit` and `gitolite` running on top of `alpine` base image.

## Deployment

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
SSH_KEY=$(cat bacnh.pub)
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

## Build docker image

```
git clone https://github.com/bacnh85/docker-gitolite-cgit.git
cd docker-gitolite-cgit/gitolite-cgit
docker build . -t bacnh85/gitolite-cgit
```

