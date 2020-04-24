#!/bin/sh

# Running once container starts
if [ ! -f "/var/lib/git/.init" ]; then
  

fi

# exec other cmds
exec "$@"