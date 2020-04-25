#!/bin/bash

function generatePassword() {
    openssl rand -hex 16
}

GIT_USR_PASSWORD=$(generatePassword)

# change ssh_key, ssh_key_name to reflect your current setup
SSH_KEY=$(cat bacnh.pub)
SSH_KEY_NAME=$(whoami)

sed -i.bak \
    -e "s#GIT_USR_PASSWORD=.*#GIT_USR_PASSWORD=${GIT_USR_PASSWORD}#g" \
    -e "s#SSH_KEY=.*#SSH_KEY=${SSH_KEY}#g" \
    -e "s#SSH_KEY_NAME=.*#SSH_KEY_NAME=${SSH_KEY_NAME}#g" \
    "$(dirname "$0")/config.env"