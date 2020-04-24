#!/bin/bash

function generatePassword() {
    openssl rand -hex 16
}

GIT_USR_PASSWORD=$(generatePassword)

sed -i.bak \
    -e "s#GIT_USR_PASSWORD=.*#GIT_USR_PASSWORD=${GIT_USR_PASSWORD}#g" \
    "$(dirname "$0")/.env"