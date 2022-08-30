#!/bin/bash

set +x

# Generate the required keys/tokens
ssh-keygen -q -N "" -t dsa -f /tmp/ssh/ssh_host_dsa_key
ssh-keygen -q -N "" -t rsa -b 4096 -f /tmp/ssh/ssh_host_rsa_key
ssh-keygen -q -N "" -t ecdsa -f /tmp/ssh/ssh_host_ecdsa_key
ssh-keygen -q -N "" -t ed25519 -f /tmp/ssh/ssh_host_ed25519_key

# Start SSHD with the example configuration
/usr/sbin/sshd -D -f /opt/ssh/sshd_config -E /tmp/sshd.log

# Echo help
echo "SSHD Server is Running"
echo "Log into the server with one of the keys set in the authorized_keys file"
cat /opt/ssh/authorized_keys

echo "Use the following user"
echo `id -u`

# Sleep
sleep inf

