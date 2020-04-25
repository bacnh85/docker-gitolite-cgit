#!/bin/bash

# change ssh_key, ssh_key_name to reflect your current setup
SSH_KEY=$(cat ~/.ssh/id_rsa.pub)
SSH_KEY_NAME=$(whoami)

sed -i.bak \
    -e "s#SSH_KEY=.*#SSH_KEY=${SSH_KEY}#g" \
    -e "s#SSH_KEY_NAME=.*#SSH_KEY_NAME=${SSH_KEY_NAME}#g" \
    "$(dirname "$0")/config.env"