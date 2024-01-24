#!/bin/bash

KEY_PATH="/root/.ssh/id_rsa_ansible"

# Check if the SSH key already exists
if [ ! -f "$KEY_PATH" ]; then
    # Generate a single SSH key pair
    ssh-keygen -t rsa -b 4096 -N '' -f $KEY_PATH

    # Set permissions for the private key
    chmod 0400 $KEY_PATH
else
    echo "SSH key already exists: $KEY_PATH"
fi

# Array of server hostnames
declare -a servers=("server1" "server2" "server3")

# Copy the SSH key to each server
for server in "${servers[@]}"; do
    sshpass -p "test123" ssh-copy-id -i /root/.ssh/id_rsa_ansible.pub -o StrictHostKeyChecking=no root@$server
done