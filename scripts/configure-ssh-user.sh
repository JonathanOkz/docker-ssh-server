#!/bin/bash

# Check if SSH_USERNAME and ENABLE_SUDO are defined
: ${SSH_USERNAME:? "Error: SSH_USERNAME not set"}
: ${ENABLE_SUDO:? "Error: ENABLE_SUDO not set"}

# Create the user if it doesn't exist
if ! id -u "$SSH_USERNAME" &>/dev/null; then
    useradd -m -s /bin/bash "$SSH_USERNAME"
    if [ $? -ne 0 ]; then
        echo "Error creating user $SSH_USERNAME"
        exit 1
    fi
    echo "User $SSH_USERNAME created"
else
    echo "User $SSH_USERNAME already exists"
fi

# Enable or disable sudo access
if [ "$ENABLE_SUDO" = "true" ]; then
    echo "$SSH_USERNAME ALL=(ALL:ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$SSH_USERNAME
    if [ $? -ne 0 ]; then
        echo "Error enabling sudo for $SSH_USERNAME"
        exit 1
    fi
    echo "Sudo access enabled for $SSH_USERNAME"
else
    echo "Sudo access not enabled for $SSH_USERNAME"
fi