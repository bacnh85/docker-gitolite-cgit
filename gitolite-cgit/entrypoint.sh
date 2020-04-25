#!/usr/bin/env sh

# Create ssh host key if not present
if [ ! -f /etc/ssh/ssh_host_rsa_key ]; then
  ssh-keygen -A
fi

# Configure gitolite
if [ ! -f "/var/lib/git/.ssh/authorized_keys" ]; then  
  echo "$SSH_KEY" > "/tmp/$SSH_KEY_NAME.pub"
  su git -c "gitolite setup -pk /tmp/$SSH_KEY_NAME.pub"  
fi

# exec other cmds
exec /usr/sbin/sshd -D -e $@