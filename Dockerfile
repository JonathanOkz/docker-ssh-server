# Use a stable Ubuntu image
FROM node:latest

# Get environment variables
ARG SSH_USERNAME
ARG ENABLE_SUDO

# Set environment variables to avoid interactive prompts during installation
ENV DEBIAN_FRONTEND=noninteractive
ENV SSH_USERNAME=${SSH_USERNAME}
ENV ENABLE_SUDO=${ENABLE_SUDO}

# Install OpenSSH server and other utilities
RUN apt-get update \
    && apt-get install -y openssh-server sudo iputils-ping telnet iproute2 curl wget \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create the directory for sshd and set permissions
RUN mkdir -p /run/sshd

# Copy custom SSH configuration
COPY config/sshd_config /etc/ssh/sshd_config

# Copy the scripts to configure the user and install software
COPY scripts/configure-ssh-user.sh /usr/local/bin/
COPY scripts/install-software.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/configure-ssh-user.sh /usr/local/bin/install-software.sh

# Run the user configuration script
RUN /usr/local/bin/configure-ssh-user.sh

# Copy authorized_keys in user directory
COPY config/authorized_keys /home/${SSH_USERNAME}/.ssh/authorized_keys
RUN chown ${SSH_USERNAME}:${SSH_USERNAME} /home/${SSH_USERNAME}/.ssh/authorized_keys

# Run the software installation script
RUN /usr/local/bin/install-software.sh

# Expose the standard SSH port
EXPOSE 22

# Start SSH server
CMD ["/usr/sbin/sshd", "-D"]