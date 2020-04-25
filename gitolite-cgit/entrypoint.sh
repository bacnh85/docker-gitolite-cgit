#!/usr/bin/env sh

# Setup gitolite admin
if [ ! -f "/var/lib/git/.ssh/authorized_keys" ]; then

  echo "$SSH_KEY" > "/tmp/$SSH_KEY_NAME.pub"
  su git -c "gitolite setup -pk /tmp/$SSH_KEY_NAME.pub" 

  exec "$@"
fi

# exec other cmds
exec "$@"