# Docker SSH Server

This project provides a Docker container based on Ubuntu that allows access to a full virtual machine via SSH.

## Features

- Secure SSH server with key-based authentication only
- Support for adding an SSH user with or without sudo access
- Node.js development environment

## Prerequisites

- Docker
- Docker Compose

## Installation

1. **Clone the repository**

   ```bash
   git clone https://github.com/JonathanOkz/docker-ssh-server.git
   cd docker-ssh-server
   ```

2. **Configure environment variables**

   Create a `.env` file in the root directory of the project and set the following variables:

   ```env
   SSH_USERNAME=my_user
   ENABLE_SUDO=false # or true depending on your needs
   SSH_PORT=2222 # or your desired port
   ```

3. **Add your authorized SSH keys**

   Create a file named `authorized_keys` in the `config` directory and add your public SSH keys:

   ```plain
   ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAr...your_public_key... user@machine
   ```

   **Note:** The `config/authorized_keys` file is copied to `/home/${SSH_USERNAME}/.ssh/authorized_keys` inside the container at creation. After the container is running, modifying `config/authorized_keys` on the host will not update the keys inside the container. To add new keys, you will need to enter the container and modify the file directly.

4. **Build and start the container**

   Use Docker Compose to build and start the container:

   ```bash
   docker-compose up -d --build
   ```

   This command will build the Docker image and start the container with the specified configurations.

5. **Connect to the container via SSH**

   Once the container is running, you can connect to it via SSH:

   ```bash
   ssh -p 2222 your_username@localhost
   ```

   Replace `2222` with the port you defined in the `.env` file if you used a different port.

## Directory Structure

```
docker-ssh-server/
├── config/
│   ├── authorized_keys
│   └── sshd_config
├── scripts/
│   ├── configure-ssh-user.sh
│   └── install-software.sh
├── .env
├── Dockerfile
├── docker-compose.yml
└── README.md
```

### Dockerfile

The `Dockerfile` installs the OpenSSH Server and configures the SSH server to accept only key-based authentication. It also copies the configuration scripts into the container.

### scripts/configure-ssh-user.sh

This script creates an SSH user, sets permissions, and enables/disables sudo access based on environment variables.

### scripts/install-software.sh

This script can be modified to easily program the installation of additional packages.

### docker-compose.yml

The `docker-compose.yml` file defines the services and volumes required to run the SSH container.

### config/sshd_config

The `sshd_config` file contains the SSH security configurations. It is copied to `/etc/ssh/sshd_config` inside the container at creation. It is ready to use but can be modified if needed.

## Contribution

Contributions are welcome! Please submit your issues and pull requests.

## License

This project is licensed under the MIT License.