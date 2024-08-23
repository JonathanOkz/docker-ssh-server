#!/bin/bash

# Update
apt-get update

# Install Zip
apt-get install zip

# Install any other packages here :


# Clean up
apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*