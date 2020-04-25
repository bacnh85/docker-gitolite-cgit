#!/usr/bin/env sh

# Validate environment variables


# Create ssh host key if not present
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  ssh-keygen -A

  # enable random git password
  GIT_PASSWORD=$(date +%s | sha256sum | base64 | head -c 32)
  echo git:$GIT_PASSWORD | chpasswd
fi

# Configure gitolite
# @todo: validate ssh-key
if [ ! -f "/var/lib/git/.ssh/authorized_keys" ]; then  
  echo "$SSH_KEY" > "/tmp/$SSH_KEY_NAME.pub"
  su git -c "gitolite setup -pk \"/tmp/$SSH_KEY_NAME.pub\""
  rm "/tmp/$SSH_KEY_NAME.pub"
fi

# exec other cmds
exec /usr/sbin/sshd -D -e $@