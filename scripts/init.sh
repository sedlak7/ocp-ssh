#!/bin/bash

set +x

# Generate the required keys/tokens
if [ ! -d /opt/ssh/sshd-keys ]; then
  mkdir -p /opt/ssh/sshd-keys
fi
if [ ! -f /opt/ssh/sshd-keys/ssh_host_rsa_key ]; then
  ssh-keygen -q -N "" -t rsa -b 4096 -f /opt/ssh/sshd-keys/ssh_host_rsa_key
fi
if [ ! -f /opt/ssh/sshd-keys/ssh_host_ecdsa_key ]; then
  ssh-keygen -q -N "" -t ecdsa -f /opt/ssh/sshd-keys/ssh_host_ecdsa_key
fi
if [ ! -f /opt/ssh/sshd-keys/ssh_host_ed25519_key ]; then
  ssh-keygen -q -N "" -t ed25519 -f /opt/ssh/sshd-keys/ssh_host_ed25519_key
fi

# Echo help
echo "Openssh-server  is Running"
echo "Log into the server with one of the keys set in the authorized_keys file"
cat /opt/ssh/authorized_keys

echo "Use the following user"
echo `id`

# Start openssh-server with the example configuration
/usr/sbin/sshd -D -f /opt/ssh/sshd_config -E /tmp/sshd.log & exec tail -F /tmp/sshd.log

# Sleep
sleep inf

