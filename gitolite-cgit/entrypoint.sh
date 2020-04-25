#!/usr/bin/env sh

# Running once container starts
if [ ! -f "/var/lib/git/.init" ]; then

  # Setup gitolite admin
  echo "$SSH_KEY" > "/tmp/$SSH_KEY_NAME.pub"
  su git -c "gitolite setup -pk /tmp/$SSH_KEY_NAME.pub"
  
  touch /var/lib/git/.init

  exec "$@"
fi

# exec other cmds
exec "$@"